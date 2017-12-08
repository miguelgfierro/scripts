#!/bin/bash
# This bash script allows to very quickly mount an external disk in a linux Azure VM.
# Link to the manual tutorial: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/classic/attach-disk
#
# Usage:
# sudo sh mount_external_disk.sh
#

echo "List of system disks"
#Check if lsscsi exists, if not install
if ! [ -x "$(command -v lsscsi)" ];then
    echo "Program lsscsi not found, installing"
    apt-get install lsscsi
fi
lsscsi

#Select disk
echo ""
read -r -p "Enter the disk you want to mount [press enter for default: /dev/sdc]: " DISK
DISK=${DISK:-/dev/sdc}
echo "The selected disk is $DISK"
DISK1="$DISK""1"
echo "The device will be $DISK1"

#Formating disk and mounting it
echo ""
read -r -p "Select mount point [press enter for default: /datadrive]: " DRIVE
DRIVE=${DRIVE:-/datadrive}
echo ""
read -r -p "Are you sure you want to mount disk $DISK1 in $DRIVE? This will format the disk [y/n]: " RESP
RESP=${RESP,,}    # tolower
if [[ $RESP =~ ^(yes|y)$ ]] 
then
    echo -e "n\np\n1\n\n\nw" | sudo fdisk $DISK
    mkfs -t ext4 $DISK1
    mkdir $DRIVE
    mount $DISK1 $DRIVE
    echo "Showing the UUID of the disk"
    sudo -i blkid
    echo ""
    #FIXME: Get the UUID automatically
    read -r -p "Enter the UUID without quotes of disk $DISK1: " UUID
    echo "
########################################
UUID=$UUID $DRIVE ext4 defaults,nofail   1   2
    " >> /etc/fstab
    echo "UUID writen to fstab. The disk will be mounted automatically every time the system is rebooted"
fi



echo "Script finished"


