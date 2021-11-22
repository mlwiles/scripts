#!/usr/bin/env python

###############################
# stdlib imports
import base64
import hashlib
import json
import os
import time
import uuid
###############################
# third party imports
import boto3
import requests

###############################
# 
# 
# constants
input_type = 'nfs'
scan_type = 'agent-pull'
max_agent_pull_retries = 10
nfs_read_dir = '/nfs/agent-output'
storage_type = 's3'
s3_region = 'eu-west-1'
s3_bucket_prefix = 'ip-scanner-results'
nfs_write_dir = '/nfs/ip-scanner-results'
ip_list = None

###############################
# 
# 
# utilities

###############################
# validateIP - input of string and validates for IPv4 format if ip addr
def validateIP(maybe_ip):
    if not isinstance(maybe_ip, str):
        raise Exception('ip not a string: %s' % maybe_ip)
    parts = maybe_ip.split('.')
    if len(parts) != 4:
        raise Exception('ip not a dotted quad: %s' % maybe_ip)
    for num_s in parts:
        try:
            num = int(num_s)
        except ValueError:
            raise Exception('ip dotted-quad components not all integers: %s' % maybe_ip)
        if num < 0 or num > 255:
            raise Exception('ip dotted-quad component not between 0 and 255: %s' % maybe_ip)

###############################
# genS3client - connect to COS
def genS3client(region=None):
    if region is None:
        return boto3.client('s3')
    else:
        return boto3.client('s3', region_name=region)
###############################
# getExistingBucketName - check for COS bucket(s)
def getExistingBucketName(client):
    response = client.list_buckets()
    for bucket in response['buckets']:
        if s3_bucket_prefix in bucket['name']:
            return bucket['name']
    return None

###############################
# genBucketName - parse out bucketname
def genBucketName():
    return s3_bucket_prefix + str(uuid.uuid4())

###############################
# createBucket - create a COS bucket
def createBucket(client, region):
    bucket_name = genBucketName()
    if region is None:
        client.create_bucket(Bucket=bucket_name)
    else:
        location = {'locationconstraint': region}
        client.create_bucket(Bucket=bucket_name, CreateBucketConfiguration=location)
    return bucket_name

###############################
# getorcreatebucketandclient - connect to COS and get access to COS bucket
def getorcreatebucketandclient(region):
    client = genS3client(region)
    bucket = getExistingBucketName(client)
    if bucket is None:
        bucket = createBucket(client)
    return client, bucket

###############################
# marshalResultsToObject
def marshalResultsToObject(results):
    v2schema = {
        'schema': 2.0,
        'results': results,
    }
    data = json.dumps(v2schema)
    hash = hashlib.md5(str.encode(data))
    b64hash = base64.encode(hash.digest())
    return data, b64hash

###############################
# dosS3Storage - push data to COS bucket
def dosS3Storage(client, bucketname, results):
    data, data_hash = marshalResultsToObject(results)
    client.put_object(
        ACL='bucket-owner-full-control',
        Body=data,
        Bucket=bucketname,
        ContentEncoding='application/json',
        ContentMD5=data_hash,
        Key=file_name,
    )

###############################
# storeResultsInS3 
def storeResultsInS3(results, region):
    client, bucketname = getorcreatebucketandclient(region)
    dosS3Storage(client, bucketname, results)

###############################
# genFileKey - returns timestamp, currently not used in file
def genFileKey():
    return time.strftime('%y-%m-%d-%h:%m:%s', time.localtime())

###############################
# 
# 
# main logic

# processing input (new types would be added here per comment in the email (nfs vs api vs ???))
if input_type == 'nfs':
    # opens file of ips and validates
    with open('path-to-ip-lists.txt') as fd:
        path_to_ip_lists = fd.read()
    ip_list = []
    for dir_name, subdir_list, file_list in os.walk(path_to_ip_lists):
        for file in file_list:
            with open(file) as fd:
                data = json.load(fd)
            ip_list.extend(data['iplist'])
            for ip in ip_list:
                validateIP(ip)  #looks like while the IP is validated, simply an exception is thrown instead of caught, logged, skipped,to allow progress
elif input_type == 'api':
    # imputs come from payload / response
    response = requests.get('https://api/iplist')
    if response.status_code != 200:
        raise Exception('non-200 status code: %d' % response.status_code)
    data = json.loads(response.text)
    ip_list = data['iplist']
    page_counter = 0
    # pagination
    while data['more'] is True:
        page_counter += 1
        response = requests.get('https://api/iplist?page=%d' % page_counter)
        if response.status_code != 200:
            raise Exception('non-200 status code: %d' % response.status_code)
        data = json.loads(response.text)
        ip_list.extend(data['iplist'])
    for ip in ip_list:
        validateIP(ip)  #looks like while the IP is validated, simply an exception is thrown instead of caught, logged, skipped,to allow progress
if ip_list is None:
    raise Exception('unrecognized input_type "%s"' % input_type)

# scan work started here
results = None
if scan_type == 'agent-pull':
    results = dict()
    for ip in ip_list:  #this is where if you pulled the IP's out above, the scanner would be able to make progress, but log those invalid one vs. exceptions or some other combination
        response = requests.get('https://%s/portdiscovery' % ip)
        if response.status_code != 200:
            raise Exception('non-200 status code: %d' % response.status_code) #curious of raising of Exceptions here?   why not just log and skip?
        data = json.loads(response.text)
        agent_url = '%s/api/2.0/status' % data['agenturl']
        response = requests.get(agent_url)
        retries = 0
        while response.status_code == 503:
            if retries > max_agent_pull_retries:
                raise Exception('max retries exceeded for ip %s' % ip) #curious of raising of Exceptions here?   why not just log and skip?
            retries += 1
            time_to_wait = float(response.headers['retry-after'])
            time.sleep(time_to_wait)
            response = requests.get(agent_url)
        if response.status_code != 200:
            raise Exception('non-200 status code: %d' % response.status_code) #curious of raising of Exceptions here?   why not just log and skip?
        results[ip] = data['status']
elif scan_type == 'nfs-read':
    results = dict()
    for ip in ip_list:
        agent_nfs_path = '%s/%s' % (nfs_read_dir, ip)
        for dir_name, subdir_list, file_list in os.walk(agent_nfs_path):
            for file in file_list:
                with open(file) as fd:
                    data = json.load(fd)
                if 'schema' not in data or float(data['schema']) < 2.0:
                    result = data
                else:
                    result = data['status']
                results[ip] = result
else:
    raise Exception('unrecognized scan_type %s' % scan_type) 

# store results, but if exceptions were hit, not results to log :)
if storage_type == 's3':
    storeResultsInS3(results, s3_region)
elif storage_type == 'nfs-write':
    file_name = time.strftime('%y-%m-%d-%h:%m:%s', time.localtime()) #why not use the method created here?  -- genFileKey()
    file_full_path = '/'.join([nfs_write_dir, file_name]) + '.json'
    v2schema = {
        'schema': 2.0,
        'results': results,
    }
    data = json.dumps(v2schema)
    with open(file_full_path, 'w') as fd:
        fd.write(data)
else:
    raise Exception('unrecognized storage_type %s' % storage_type)

