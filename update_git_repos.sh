#!/bin/bash
#
# This script updates all git repos for a user
#
USER="hoaphumanoid" 
#declare folders
declare -a arr=("sciblog" "scripts" "twitter_bot")
echo "Updating git repos of user $USER ......."
for i in ${arr[@]}
do
	cd $i
	echo "Updating repo $i"
	git pull 
	cd ..
done
