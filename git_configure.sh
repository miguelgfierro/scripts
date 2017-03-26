#!/bin/bash
#
# This script configure some global options in git like aliases, credential helper,
# user name and email. To use:
# $ sh git_configure.sh 
#
echo ""
echo "Configuring git..."
echo "Write your git username"
read USER
DEFAULT_EMAIL="$USER@users.noreply.github.com"
read -p "Write your git email [Press enter to accept the private email $DEFAULT_EMAIL]: " EMAIL
EMAIL="${EMAIL:-${DEFAULT_EMAIL}}"

echo "Configuring global user name and email..."
git config --global user.name "$USER"
git config --global user.email "$EMAIL"

echo "Configuring global aliases..."
git config --global alias.ci commit
git config --global alias.st status
git config --global core.editor "vim"
git config --global credential.helper 'cache --timeout=36000'

read -r -p "Do you want to add ssh credentials for git? [y/n] " RESP
RESP=${RESP,,}    # tolower
if [[ $RESP =~ ^(yes|y)$ ]]
then
    echo "Configuring git ssh access..."
    ssh-keygen -t rsa -b 4096 -C "$EMAIL"
    echo "This is your public key"
    cat ~/.ssh/id_rsa.pub
fi
echo "git configured"

