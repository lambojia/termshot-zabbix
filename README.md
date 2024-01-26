# Setup

1. Download & Extract tar.gz in your repo's root. see [Releases](https://github.com/lambojia/termshot-zabbix/tags)
```
wget -qO- https://github.com/lambojia/termshot-zabbix/archive/refs/tags/latest.tar.gz | tar xvz
```
2. Create a directory for storing artifacts w/in your repo. ie: ./artifacts

3. Create a conf file within the directory you created. ie: ./artifacts/conf

_Sample Config._
```
{
"hosts": [
    {
        "host": "zabbix-client",
        "paths": [
            {
                "path": "/etc/hosts",
                "command": "cat"
            },
            {
                "path": "/etc/os-release",
                "command": "cat"
            },
            {
                "path": "/etc/passwd",
                "command": "base64"
            },
            {
                "path": "/etc/zabbix/zabbix_agentd.conf",
                "command": "cat"
            }
        ]        
    },
    {
        "host": "zabbix-server",
        "paths": [
            {
                "path": "/etc/hosts",
                "command": "cat"
            },
            {
                "path": "/etc/os-release",
                "command": "cat"
            },
            {
                "path": "/etc/passwd",
                "command": "base64"
            }
        ]        
    }]
}
```
4. Commit changes into your repo.

5. [Generate a Fine-grained personal access token] (https://github.com/settings/personal-access-tokens/new)

    Grant it access to your repo with ff: permissions
   
        Read access to metadata
   
        Read and Write access to code and pull requests

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
https://api.github.com/repos/${user}/${repo}/contents/termshot-zabbix-latest/scripts/install_termshot.sh | jq -r ".content" | base64 -d | sh -s $workdir
```

### Artifact Capture Script

Clone Script and set a suitable name ie: 02 - Capture Artifact

Command:
```
token="<Personal Access Token>"
workdir="/var/tmp/termshot"
user="<git org/user>"
repo="<git repo>"
artifact="<artifact storage path>"

curl -sL \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer $token" \
-H "X-GitHub-Api-Version: 2022-11-28" \
https://api.github.com/repos/${user}/${repo}/contents/termshot-zabbix-latest/scripts/capture_artifact-v2.sh | jq -r ".content" | base64 -d | sh -s $token $user $repo $artifact
```


