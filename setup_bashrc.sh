#!/bin/bash
#
# Set up several functions to .bashrc like cs (a combination of cd+ls), ccat 
# (cat with color) or reimplement evince to run in background.
#
# To set up the bashrc script in Windows using cygwin it is necessary to add
# at the beginning of the script to fix a problem with newlines the following:
# (set -o igncr) 2>/dev/null && set -o igncr;
#
# IMPORTANT!!!
# METHOD OF USE:
#
# source setup_bashrc.sh
#
# We have to source the file instead of using sh. The reason is because the line
# source ~./.bashrc will source the file in the sub-shell, i.e. a shell which 
# is started as child process of the main shell.

# Create save path file if it is not created
if [ ! -e ~/.sp ] ; then
    touch ~/.sp
fi

echo "
################################################################################
#Hide user name and host in terminal and make ls every time a terminal opens
export PS1="\w$ "
ls

#cd + ls
function cs () {
    cd \$1
    ls -a
}

#transfer path: save the current path to a hidden file
function tp () {
    pwd > ~/.sp
}

#goto transfer path: goes where the previously saved tp points
function gtp () {
    cs \`cat ~/.sp\`
}

#cat with color
function ccat () {
    source-highlight -fesc -i \$1
}

#Remove trash from terminal and runs program in background
function evince () {
    /usr/bin/evince \$* 2> /dev/null & disown
}
function gedit (){
        /usr/bin/gedit \$* 2> /dev/null & disown
}

" >> ~/.bashrc

source ~/.bashrc
echo ".bashrc updated"

