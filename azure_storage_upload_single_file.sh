#!/bin/bash
#
# This bash script allows to upload a file to Azure Blob Storage.
#
# Usage:
# sh azure_storage_upload_single_file.sh account_name account_key local_folder file_name destination_container
# Example:
# sh azure_storage_upload_single_file.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp test.csv tmp_container
#
# More info here: https://docs.microsoft.com/en-us/azure/storage/storage-azure-cli-nodejs
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
LOCAL_FOLDER=$3
FILE_NAME=$4
CONTAINER_NAME=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_storage_upload_single_file.sh account_name account_key local_folder file_name destination_container"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_ACCESS_KEY=$ACCOUNT_KEY

azure config mode arm
azure storage blob upload $LOCAL_FOLDER/$FILE_NAME $CONTAINER_NAME $FILE_NAME


