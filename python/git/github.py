import githubcommon

owner = "mwiles"
repoName = "REPO NAME"
token = "TOKEN HERE"

title = "Title Here"
description = "Description Here"
label = "work-learn"

newissue = githubcommon.newGithubIssue(owner, repoName, token, title, description, label)
print(newissue)
issue = githubcommon.getGitIssue(owner, repoName, token, newissue)

state = "open"
issues = githubcommon.getGitIssuesByState(owner, repoName, token, state)
