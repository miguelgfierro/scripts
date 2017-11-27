#!/bin/bash
#
# This bash script allows to download a file to Azure Blob Storage.
#
# Usage:
# sh azure_storage_download_single_file.sh account_name account_key remote_filepath container_name local_filepath
# Example:
# sh azure_storage_download_single_file.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/test.csv tmp_container /data/temp.csv
#
# More info here: https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
REMOTE_FILEPATH=$3
CONTAINER_NAME=$4
LOCAL_FILEPATH=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_storage_download_single_file.sh account_name account_key remote_filepath container_name local_filepath"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

az storage blob download --name $REMOTE_FILEPATH --container-name $CONTAINER_NAME --file $LOCAL_FILEPATH


