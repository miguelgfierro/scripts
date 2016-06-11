#!/bin/bash
#
# This script updates all git repos for a user. The script should be located in a root folder containing each repo folder.
#
USER="hoaphumanoid" 
#declare folders
declare -a arr=("sciblog" "scripts" "twitter_bot")
echo "Git state repos of user $USER ......."
for i in ${arr[@]}
do
	cd $i
	echo "STATE REPO: $i"
	git status 
	cd ..
done
