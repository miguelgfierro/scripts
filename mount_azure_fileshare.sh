#!/bin/bash
#
# This bash script allows to mount a fileshare storage in a linux VM. 
# Before executing dist you have to create a fileshare in your storage account. For that go to https://ms.portal.azure.com,
# select your storage, under Services press Files, create a File Share with a name and a size (max. 5Tb). The name you 
# chose is $FILESHARE_NAME in this script.  
#
# WARNING: The VM and the storage has to be in the same region!
#
# Usage:
# sudo bash mount_azure_fileshare.sh storage_name storage_key fileshare_name mount_point
# Example:
# sudo bash mount_azure_fileshare.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== fileshare_data /mnt/fileshare
#
# More info here: https://docs.microsoft.com/en-us/azure/storage/storage-how-to-use-files-linux
#

STORAGE_NAME=$1
STORAGE_KEY=$2
FILESHARE_NAME=$3
MOUNT_POINT=$4

if [ "$#" -ne 4 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh mount_azure_fileshare.sh storage_name storage_key fileshare_name mount_point"
  echo ""
  exit 1
fi

sudo mkdir -p $MOUNT_POINT
sudo mount -t cifs //$STORAGE_NAME.file.core.windows.net/$FILESHARE_NAME $MOUNT_POINT -o vers=3.0,username=$STORAGE_NAME,password=$STORAGE_KEY,dir_mode=0777,file_mode=0777

read -r -p "Do you want to Persist the fileshare mount through reboots? [y/n] " RESP
RESP=${RESP,,}    # tolower
if [[ $RESP =~ ^(yes|y)$ ]]
then
    sudo echo "
################################
#Line automatically added by the script: mount_azure_fileshare.sh
//$STORAGE_NAME.file.core.windows.net/$FILESHARE_NAME $MOUNT_POINT cifs vers=3.0,username=$STORAGE_NAME,password=$STORAGE_KEY,dir_mode=0777,file_mode=0777
    " >> /etc/fstab
fi
echo "Fileshare configured"
