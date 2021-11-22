
# https://api.slack.com/methods/users.list/code
# 
import logging
import os

# Import WebClient from Python SDK (github.com/slackapi/python-slack-sdk)
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

# WebClient insantiates a client that can call API methods
# When using Bolt, you can use either `app.client` or the `client` passed to listeners.
# https://slack.dev/python-slack-sdk/web/index.html#calling-any-api-methods
# client = WebClient(token=os.environ.get("SLACK_BOT_TOKEN"))
# https://api.slack.com/apps
client = WebClient(token="REDACTED")
logger = logging.getLogger(__name__)

# You probably want to use a database to store any user information ;)
users_store = {}

# Put users into the dict
def save_users(users_array):
    for user in users_array:
        # Key user info on their unique user ID
        user_id = user["id"]
        # Store the entire user object (you may not need all of the info)
        users_store[user_id] = user

try:
    # Call the users.list method using the WebClient
    # users.list requires the users:read scope
    response = client.conversations_members(channel="december-8th")
    save_users(response["members"])

except SlackApiError as e:
    logger.error("Error creating conversation: {}".format(e))


