#!/bin/bash
#
# This script configure some global options in git like aliases, credential helper,
# user name and email. Tested in Ubuntu and Mac. 
#
# Method of use:
# source git_configure.sh
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
git config --global alias.br branch
git config --global alias.co checkout
git config --global alias.last 'log -1 HEAD'
git config --global alias.sub "submodule update --remote --merge"
git config --global core.editor "vim"
git config --global credential.helper 'cache --timeout=36000'

read -r -p "Do you want to add ssh credentials for git? [y/n] " RESP
RESP=${RESP,,}    # tolower (only works with /bin/bash)

if [[ $RESP =~ ^(yes|y)$ ]]
then
    echo "Configuring git ssh access..."
    # Create .ssh directory if it doesn't exist
    SSH_DIR="$HOME/.ssh"
    mkdir -p "$SSH_DIR"
    
    # Set default key path
    DEFAULT_KEY_PATH="$HOME/.ssh/id_ed25519"
    
    # Generate the key - ssh-keygen will prompt for the file location
    ssh-keygen -t ed25519 -C "$EMAIL"
    
    # Get the actual key path from user input (stored in the last line of ssh-keygen output)
    read -p "Please enter the path you just specified for the key: " KEY_PATH
    KEY_PATH="${KEY_PATH:-${DEFAULT_KEY_PATH}}"
    
    if [ -f "${KEY_PATH}.pub" ]; then
        echo "This is your public key. To activate it in github, got to settings, SHH and GPG keys, New SSH key, and enter the following key:"
        cat "${KEY_PATH}.pub"
        echo -e "\nTo work with the ssh key, you have to clone all your repos with ssh instead of https. For example, for this repo you will have to use the url: git@github.com:miguelgfierro/scripts.git"
    else
        echo "Failed to find public key at ${KEY_PATH}.pub"
    fi
fi

if [ "$(uname)" == "Darwin" ]; then # Mac OS X platform  
	echo "Setting autocompletion"
	AUTOCOMPLETION_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"
	AUTOCOMPLETION_PATH=/opt/local/etc/bash_completion.d
	AUTOCOMPLETION_SCRIPT=git-completion.bash 
	sudo mkdir -p $AUTOCOMPLETION_PATH
	sudo curl  -o $AUTOCOMPLETION_PATH/$AUTOCOMPLETION_SCRIPT $AUTOCOMPLETION_URL
	source $AUTOCOMPLETION_PATH/$AUTOCOMPLETION_SCRIPT
	echo "source $AUTOCOMPLETION_PATH/$AUTOCOMPLETION_SCRIPT" >> ~/.bash_profile
fi
echo ""
echo "git configured"

