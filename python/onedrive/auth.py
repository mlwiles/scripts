import msal
import requests

# Your application's client ID and client secret obtained from Azure Portal
CLIENT_ID = "your_client_id"
CLIENT_SECRET = "your_client_secret"

# Scopes required by your application to access OneDrive
SCOPES = ["User.Read", "Files.ReadWrite"]

# URL to redirect to after authentication (configured in Azure Portal)
REDIRECT_URI = "http://localhost:5000/get_token"

# Initialize the MSAL application
app = msal.ConfidentialClientApplication(
    CLIENT_ID,
    authority="https://login.microsoftonline.com/common",
    client_credential=CLIENT_SECRET
)

# Get the authorization URL for the user to authenticate
auth_url = app.get_authorization_request_url(SCOPES, redirect_uri=REDIRECT_URI)

print("Please go to this URL and authenticate:", auth_url)
# Once authenticated, you will be redirected to the redirect_uri with a code in the query string

# Exchange the authorization code for an access token
authorization_code = input("Enter the authorization code from the redirect URL: ")
token_response = app.acquire_token_by_authorization_code(
    authorization_code,
    scopes=SCOPES,
    redirect_uri=REDIRECT_URI
)

# Extract the access token
access_token = token_response.get("access_token")

# Use the access token to make API requests to OneDrive
if access_token:
    headers = {
        "Authorization": "Bearer " + access_token
    }

    # Example: Get the user's profile
    profile_response = requests.get("https://graph.microsoft.com/v1.0/me", headers=headers)
    print("User's profile:", profile_response.json())

    # Example: List files in the root folder of OneDrive
    files_response = requests.get("https://graph.microsoft.com/v1.0/me/drive/root/children", headers=headers)
    print("Files in OneDrive:", files_response.json())
else:
    print("Failed to obtain access token")