#!/bin/bash
#
# This bash script allows to upload a file to Azure Blob Storage.
#
# Usage:
# sh azure_storage_upload_single_file.sh account_name account_key local_filepath container_name remote_filepath
# Example:
# sh azure_storage_upload_single_file.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/test.csv tmp_container /data/temp.csv
#
# More info here: https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
LOCAL_FILEPATH=$3
CONTAINER_NAME=$4
REMOTE_FILEPATH=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_storage_upload_single_file.sh account_name account_key local_filepath container_name remote_filepath"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

az storage blob upload --file $LOCAL_FILEPATH --container-name $CONTAINER_NAME --name $REMOTE_FILEPATH


