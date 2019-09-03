#! /bin/bash

# Installation of many packages in a fresh Ubuntu

###################################
# Add repositories
###################################
echo
echo "Installing repositories..."
echo
sudo apt-add-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo add-apt-repository ppa:webupd8team/java
sudo add-apt-repository ppa:ubuntu-x-swat/x-updates # nvidia
sudo add-apt-repository ppa:transmissionbt/ppa
sudo add-apt-repository ppa:jd-team/jdownloader

###################################
# Update and Upgrade
###################################
echo
echo "Updating and upgrading..."
echo
sudo apt-get update && sudo apt-get upgrade -y

###################################
# Remove programs not used
###################################
echo
echo "Removing programs not used..."
echo
sudo apt-get remove hexchat hexchat-common thunderbird thunderbird-gnome-support thunderbird-locale-en  thunderbird-locale-en-us  banshee tomboy pidgin pidgin-libnotify -y

###################################
# Installations
###################################
echo
echo "Installing programs..."
echo

## system
### important
sudo apt-get install tasksel gparted p7zip-rar ntfs-config usbmount -y
### desktop
sudo apt-get remove xscreensaver xscreensaver-data xscreensaver-gl  indicator-multiload -y
sudo apt-get install xdotool gnome-screensaver -y
### nautilus complements
sudo apt-get install nautilus nautilus-dropbox nautilus-open-terminal -y
### java and pdf tools
sudo apt-get install oracle-java7-installer
### pdf tools
sudo apt-get install  acroread cups-pdf -y
## audio, image and video
sudo apt-get install inkscape
### tools
sudo apt-get install mencoder vlc audacious skype brasero -y
### torrent and direct download
sudo apt-get install jdownloader -y

## developing
### compilers and IDEs
sudo apt-get install build-essential gcc-avr avr-libc doxygen doxygen-latex cmake cmake-curses-gui gfortran libgtk2.0-dev pkg-config -y
sudo apt-get install qtcreator qtcreator-plugin-cmake -y
### libraries
sudo apt-get install libboost-all-dev libeigen3-dev libblas-dev liblapack-dev ant -y
### python
sudo apt-get install python-tk python-matplotlib python-pip  -y
sudo easy_install ipython jinja2 tornado pyzmq scipy scikit-image
### repositories
sudo apt-get install git ssh openssh-server filezilla filezilla-common -y
### tools
sudo apt-get install kdiff3-qt vim source-highlight -y
### latex
sudo apt-get install texlive-latex-base texlive-base texlive-latex-extra texlive-font-utils texlive-fonts-recommended texlive-generic-recommended texlive-generic-extra texlive-omega texlive-plain-extra texlive-extra-utils texlive-lang-spanish texlive-lang-english texlive-pictures texlive-math-extra texlive-science -y
sudo apt-get install gedit-plugins/trusty gedit-latex-plugin -y
### web tools
echo "To install LAMP:"
#echo "Launch Synaptic. Edit Menu, Package by task, LAMP Server"
sudo apt-get install php5 -yy
sudo apt-get install mysql-client mysql-server mysql-workbench -y
sudo apt-get install phpmyadmin phpsysinfo -y
###################################
# Cleaning
###################################
echo
echo "Cleaning..."
sudo apt-get autoclean

###################################
# Configuring
###################################
echo
echo "Configuring..."
## java
sudo update-alternatives --config java



###################################
# Finish!
###################################
echo
echo "Finish! All done!"
echo
