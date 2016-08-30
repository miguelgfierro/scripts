#!/bin/bash
#
# This script configure some global options in git like aliases, credential helper,
# user name and email. To use:
# $ sh configure.sh 
#
echo "Configuring git"
echo "Write your git username"
read USER
echo "Write your git email"
read EMAIL

echo "Configuring global user name and email"
git config --global user.name "$USER"
git config --global user.email "$EMAIL"

echo "Configuring global aliases"
git config --global alias.ci commit
git config --global alias.st status
git config --global credential.helper 'cache --timeout=36000'

echo "Configuring git ssh access"
ssh-keygen -t rsa -b 4096 -C "$EMAIL"

