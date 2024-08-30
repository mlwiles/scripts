#!/usr/bin/env python

import base64
import hashlib
import json
import os
import time
import uuid
import boto3
import requests

# Constants
INPUT_TYPE = 'nfs'
SCAN_TYPE = 'agent-pull'
MAX_AGENT_PULL_RETRIES = 10
NFS_READ_DIR = '/nfs/agent-output'
STORAGE_TYPE = 's3'
S3_REGION = 'eu-west-1'
S3_BUCKET_PREFIX = 'ip-scanner-results'
NFS_WRITE_DIR = '/nfs/ip-scanner-results'


def validate_ip(ip):
    """Validates that the input is a proper IPv4 address."""
    if not isinstance(ip, str):
        raise ValueError(f'IP address must be a string: {ip}')
    parts = ip.split('.')
    if len(parts) != 4:
        raise ValueError(f'IP address is not a dotted quad: {ip}')
    for part in parts:
        try:
            num = int(part)
            if not 0 <= num <= 255:
                raise ValueError(f'IP component out of range: {part} in {ip}')
        except ValueError:
            raise ValueError(f'IP components must be integers: {part} in {ip}')


def load_ips_from_nfs(file_path):
    """Load IPs from NFS."""
    with open(file_path) as fd:
        path_to_ip_lists = fd.read().strip()
    
    ip_list = []
    for dir_name, _, file_list in os.walk(path_to_ip_lists):
        for file in file_list:
            with open(os.path.join(dir_name, file)) as fd:
                data = json.load(fd)
            ip_list.extend(data.get('iplist', []))
    
    for ip in ip_list:
        validate_ip(ip)
    
    return ip_list


def load_ips_from_api(api_url):
    """Load IPs from an API."""
    ip_list = []
    page = 0

    while True:
        response = requests.get(f'{api_url}?page={page}')
        if response.status_code != 200:
            raise Exception(f'Non-200 status code: {response.status_code}')

        data = response.json()
        ip_list.extend(data.get('iplist', []))
        
        if not data.get('more'):
            break
        page += 1

    for ip in ip_list:
        validate_ip(ip)

    return ip_list


def get_ip_list(input_type):
    """Get the list of IPs based on the input type."""
    if input_type == 'nfs':
        return load_ips_from_nfs('path-to-ip-lists.txt')
    elif input_type == 'api':
        return load_ips_from_api('https://api/iplist')
    else:
        raise ValueError(f'Unrecognized input_type "{input_type}"')


def scan_agent_pull(ip_list):
    """Perform the agent-pull scan type."""
    results = {}
    for ip in ip_list:
        response = requests.get(f'https://{ip}/portdiscovery')
        if response.status_code != 200:
            raise Exception(f'Non-200 status code: {response.status_code}')
        
        data = response.json()
        agent_url = f"{data['agenturl']}/api/2.0/status"
        retries = 0

        while retries <= MAX_AGENT_PULL_RETRIES:
            response = requests.get(agent_url)
            if response.status_code == 200:
                results[ip] = response.json().get('status', 'unknown')
                break
            elif response.status_code == 503:
                retries += 1
                time_to_wait = float(response.headers.get('retry-after', 1))
                time.sleep(time_to_wait)
            else:
                raise Exception(f'Non-200 status code: {response.status_code} after {retries} retries')

        if retries > MAX_AGENT_PULL_RETRIES:
            raise Exception(f'Max retries exceeded for IP {ip}')

    return results


def scan_nfs_read(ip_list):
    """Perform the NFS-read scan type."""
    results = {}
    for ip in ip_list:
        agent_nfs_path = os.path.join(NFS_READ_DIR, ip)
        for dir_name, _, file_list in os.walk(agent_nfs_path):
            for file in file_list:
                with open(os.path.join(dir_name, file)) as fd:
                    data = json.load(fd)
                schema_version = float(data.get('schema', 1.0))
                result = data if schema_version < 2.0 else data.get('status')
                results[ip] = result

    return results


def store_results_in_s3(results, region):
    """Store the results in an S3 bucket."""
    client, bucket_name = get_or_create_bucket_and_client(region)
    file_key = gen_file_key()
    data, data_hash = marshal_results_to_object(results)
    client.put_object(
        ACL='bucket-owner-full-control',
        Body=data,
        Bucket=bucket_name,
        ContentEncoding='application/json',
        ContentMD5=data_hash,
        Key=file_key,
    )


def get_or_create_bucket_and_client(region):
    """Get or create an S3 bucket and client."""
    client = gen_s3_client(region)
    bucket_name = get_existing_bucket_name(client)

    if bucket_name is None:
        bucket_name = create_bucket(client, region)

    return client, bucket_name


def gen_s3_client(region=None):
    """Generate an S3 client."""
    return boto3.client('s3', region_name=region) if region else boto3.client('s3')


def get_existing_bucket_name(client):
    """Get the name of an existing S3 bucket."""
    response = client.list_buckets()
    for bucket in response.get('Buckets', []):
        if S3_BUCKET_PREFIX in bucket['Name']:
            return bucket['Name']
    return None


def create_bucket(client, region):
    """Create a new S3 bucket."""
    bucket_name = gen_bucket_name()
    if region:
        location = {'LocationConstraint': region}
        client.create_bucket(Bucket=bucket_name, CreateBucketConfiguration=location)
    else:
        client.create_bucket(Bucket=bucket_name)
    return bucket_name


def gen_bucket_name():
    """Generate a unique bucket name."""
    return f"{S3_BUCKET_PREFIX}-{uuid.uuid4()}"


def marshal_results_to_object(results):
    """Marshal the results to a JSON object and compute its MD5 hash."""
    v2schema = {'schema': 2.0, 'results': results}
    data = json.dumps(v2schema)
    data_hash = base64.b64encode(hashlib.md5(data.encode('utf-8')).digest()).decode('utf-8')
    return data, data_hash


def gen_file_key():
    """Generate a file key for storing results."""
    return time.strftime('%Y-%m-%d-%H-%M-%S', time.localtime()) + '.json'


def store_results_locally(results):
    """Store the results in a local NFS directory."""
    file_name = gen_file_key()
    file_full_path = os.path.join(NFS_WRITE_DIR, file_name)
    with open(file_full_path, 'w') as fd:
        json.dump({'schema': 2.0, 'results': results}, fd)


def main():
    ip_list = get_ip_list(INPUT_TYPE)
    if SCAN_TYPE == 'agent-pull':
        results = scan_agent_pull(ip_list)
    elif SCAN_TYPE == 'nfs-read':
        results = scan_nfs_read(ip_list)
    else:
        raise ValueError(f'Unrecognized scan_type {SCAN_TYPE}')

    if STORAGE_TYPE == 's3':
        store_results_in_s3(results, S3_REGION)
    elif STORAGE_TYPE == 'nfs-write':
        store_results_locally(results)
    else:
        raise ValueError(f'Unrecognized storage_type {STORAGE_TYPE}')


if __name__ == '__main__':
    main()
