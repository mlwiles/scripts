import json, requests

###################################################
#https://github.com/ZenHubIO/API#get-the-zenhub-board-data-for-a-repository 
def getZenhubPipelines(pRepoId, pToken):
  query_url = f"https://zenhub.ibm.com/p1/repositories/{pRepoId}/board?access_token={pToken}"

  request = requests.get(query_url)
  data = request.content
  pipelines = json.loads(data)

  for pipeline in pipelines['pipelines']:
    print(pipeline['name'], pipeline['id']) 


