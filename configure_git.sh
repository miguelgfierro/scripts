#!/bin/bash
#
# This script configure some global options in git like aliases, credential helper,
# user name and email. To use:
# $ sh configure.sh username email@example.com 
#

USER=$1
EMAIL=$2

git config --global user.name "$USER"
git config --global user.email "$EMAIL"

git config --global alias.ci commit
git config --global alias.st status
git config --global credential.helper 'cache --timeout=36000'



