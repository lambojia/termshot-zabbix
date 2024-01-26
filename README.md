
# Setup

Clone this repo into your repo for storing artifacts

## Create and Administration Script in the Zabbix Administration UI.

### Termshot Installation Script

![image](https://github.com/lambojia/termshot-zabbix/assets/125809843/f21a4050-534c-4200-8c95-001e3793786d)

Command:
```
token="<Personal Access Token>"
workdir="/var/tmp/termshot"
user="<git org/user>"
repo="<git repo>"

curl -sL \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer $token" \
-H "X-GitHub-Api-Version: 2022-11-28" \
https://api.github.com/repos/${user}/${repo}/contents/scripts/install_termshot.sh | jq -r ".content" | base64 -d | sh -s $workdir
```

### Artifact Capture Script

Clone Script and set a suitable name ie: 02 - Capture Artifact

Command:
```
token="<Personal Access Token>"
workdir="/var/tmp/termshot"
user="<git org/user>"
repo="<git repo>"

curl -sL \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer $token" \
-H "X-GitHub-Api-Version: 2022-11-28" \
https://api.github.com/repos/${user}/${repo}/contents/scripts/capture_artifact.sh | jq -r ".content" | base64 -d | nohup sh -s $token $user $repo 2>/dev/null &
```
