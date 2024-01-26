#!/bin/sh

set -e

#PARAMS: 1 - work directory

if which termshot >/dev/null; then

  termshot -v

elif which "${1}/termshot" >/dev/null; then

  eval "${1}/termshot -v"

else

	mkdir -p $1

	cd $1 

	wget -q https://github.com/homeport/termshot/releases/download/v0.2.7/termshot_0.2.7_linux_amd64.tar.gz 

	tar -xf termshot_0.2.7_linux_amd64.tar.gz

	echo "Termshot installed in ${1}"

	exit 0

fi

echo "Skipping installation, Termshot is already installed."