#!/bin/sh

set -e

#PARAMS: 1 - work directory , 2 - termshot releases url

if which termshot >/dev/null; then

  termshot -v

elif which "${1}/termshot" >/dev/null; then

  eval "${1}/termshot -v"

else

	mkdir -p $1

	cd $1 

	wget -q $2 

	tar -xf termshot_0.2.7_linux_amd64.tar.gz

	echo "Termshot installed in ${1}"

	exit 0

fi

echo "Skipping installation, Termshot is already installed."