import githubcommon

owner = "mwiles"
repoName = "work"
token = "7d06b5c398f2be4bff5af56d7a4da58129bb7a82"

title = "Title Here"
description = "Description Here"
label = "work-learn"

newissue = githubcommon.newGithubIssue(owner, repoName, token, title, description, label)
print(newissue)
issue = githubcommon.getGitIssue(owner, repoName, token, newissue)

state = "open"
issues = githubcommon.getGitIssuesByState(owner, repoName, token, state)
