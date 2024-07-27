import requests
import json

# Define your OneDrive API credentials
CLIENT_ID = 'your_client_id'
CLIENT_SECRET = 'your_client_secret'
REDIRECT_URI = 'http://localhost:8080'  # Example redirect URI, update as needed
SCOPE = 'offline_access files.readwrite.all'

# Authenticate and obtain access token
def authenticate():
    token_url = 'https://login.microsoftonline.com/common/oauth2/v2.0/token'
    data = {
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'redirect_uri': REDIRECT_URI,
        'scope': SCOPE,
        'grant_type': 'client_credentials'
    }
    response = requests.post(token_url, data=data)
    return response.json().get('access_token')

# Get recursive list of files and folders
def get_files_folders(access_token, parent_folder_id='root'):
    url = f'https://graph.microsoft.com/v1.0/me/drive/items/{parent_folder_id}/children?$select=id,name,folder,file'
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    response = requests.get(url, headers=headers)
    data = response.json()
    
    if 'value' in data:
        for item in data['value']:
            if 'folder' in item:
                print(f"Folder: {item['name']}")
                get_files_folders(access_token, item['id'])  # Recursively call for subfolders
            elif 'file' in item:
                print(f"File: {item['name']}")
    
# Main function
def main():
    access_token = authenticate()
    if access_token:
        print("Authentication successful.")
        get_files_folders(access_token)
    else:
        print("Authentication failed.")

if __name__ == "__main__":
    main()
