#!/bin/bash

# Set up several functions to .bashrc like cs (a combination of cd+ls), ccat 
# (cat with color) or reimplement evince to run in background.

echo "
################################################################################
#Hide user name and host in terminal and make ls every time a terminal opens
export PS1="\w$ "
ls

#cd + ls
function cs () {
    cd $1
    ls -a
}

#transfer path: save the current path to a hidden file
function tp () {
    pwd > ~/.sp
}

#go to transfer path: goes where the previously saved tp points
function gtp () {
    cs `cat ~/.sp`
}

#cat with color
function ccat () {
    source-highlight -fesc -i $1
}

#Remove trash from terminal and runs program in background
function evince () {
    /usr/bin/evince $* 2> /dev/null & disown
}
function gedit (){
	/usr/bin/gedit $* 2> /dev/null & disown
}

" >> ~/.bashrc

echo .bashrc updated
