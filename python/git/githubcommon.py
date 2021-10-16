import json, requests
from requests.models import Response

###################################################
#https://docs.github.com/en/rest/reference/issues 
def getGitIssuesByState(pOwner, pRepo, pToken, pState):
  query_url = f"https://api.github.ibm.com/repos/{pOwner}/{pRepo}/issues"
  params = {
      "state": pState
  }
  headers = {'Authorization': f'token {pToken}'}

  request = requests.get(query_url, headers=headers, params=params)
  data = request.content
  response = json.loads(data)

  return response

###################################################
#https://docs.github.com/en/rest/reference/issues 
def getGitIssue(pOwner, pRepo, pToken, pNumber):
  query_url = f"https://api.github.ibm.com/repos/{pOwner}/{pRepo}/issues/{pNumber}"
  headers = {'Authorization': f'token {pToken}'}

  request = requests.get(query_url, headers=headers)
  data = request.content
  response = json.loads(data)

  return response

###################################################
#https://developer.github.com/v3/issues/#create-an-issue    
def newGithubIssue(pOwner, pRepo, pToken, pTitle, pDescription, pLabel):
  query_url = f"https://api.github.ibm.com/repos/{pOwner}/{pRepo}/issues"
  jsondata = {
    "title": pTitle,
    "body": pDescription,
    "labels": [ pLabel ] 
  }
  headers = {
    'Authorization': f'token {pToken}'
  }

  request = requests.post(query_url, headers=headers, json=jsondata)
  data = request.content
  response = json.loads(data)
  
  number = 0
  if response:
    number = response['number']
  return number