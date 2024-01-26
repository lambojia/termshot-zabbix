#!/bin/sh

set -e

#PARAMS: 
# 1 - git pat token 
# 2 - git org/user
# 3 - git repo  
# 4 - host work directory 
# 5 - artifacts path

cd ${4}

#prechecks for termshot bin
if which termshot >/dev/null; then
  termshot_command="termshot"
  termshot -v
elif which ./termshot >/dev/null; then
  termshot_command="../termshot"
  ./termshot -v
else
  echo "Termshot needs to be Installed first"
  exit 1
fi

#Get hostname
client=$(uname -n)

#Create temp work directory
workdir=$(pwd)/$(cat /proc/sys/kernel/random/uuid)
mkdir -p $workdir
cd $workdir


#Get paths for capture
curl -sL \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer $1" \
-H "X-GitHub-Api-Version: 2022-11-28" \
"https://api.github.com/repos/${2}/${3}/contents/${5}/conf" | jq -r ".content" | base64 -d | jq -c '.hosts[] | select(.host == "'${client}'") | .paths[]' | while read i; do
    
    path=$(echo $i | jq -r ".path")

    if [ -r $path ] 
    then

      mkdir -p ".${path}" #Create directory for storing capture
      time_stamp=$(date --utc +%FT%TZ)
      filename=".${path}/artifact-${time_stamp}.png"
      command=$(echo $i | jq -r ".command")

      #execute termshot to capture path
      eval "timeout 10 ${command} ${path} | ${termshot_command} -f ${filename} /bin/sh >/dev/null" 

      exit_status=$?

      if [ $exit_status = 127 ]
      then
        echo "Execution time'd out. consider truncation"
      elif [ $exit_status = 0 ]
      then

        #create json payload for git upload
        echo -n '
        {
                "message":"Artifact Capture '${time_stamp}'",
                "content":"'$(base64 -w 0 $filename)'",
                "committer":
                        {
                                "name":"'$(whoami)'",
                                "email":"'$(whoami)@$(hostname --fqdn)'"
                        }
        }' > "${filename}.json"

        #upload to git
        curl -s -X PUT -d @"${filename}.json" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${1}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/${2}/${3}/contents/${5}/${client}${path}/$(basename $filename)"

        echo "Screen Captured ${path} to ${filename}"

      fi

    else
      echo "File $path does not exist or is not Accessible by $(whoami)"
    fi

done