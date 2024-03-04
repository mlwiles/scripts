import json, requests
import zenhubcommon

repoId = "REPO ID"
token = "TOKEN HERE"

zenhubcommon.getZenhubPipelines(repoId, token)