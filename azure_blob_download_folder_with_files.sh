#!/bin/bash
#
# This bash script allows to upload a folder to Azure Blob Storage.
#
# Usage:
# sh azure_blob_download_folder_with_files.sh account_name account_key remote_folder container_name local_folder
# Example:
# sh azure_blob_download_folder_with_files.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== data tmp_container /tmp/data
#
# More info here: https://docs.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-download-batch
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
REMOTE_FOLDER=$3
CONTAINER_NAME=$4
LOCAL_FOLDER=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR: Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_blob_download_folder_with_files.sh account_name account_key remote_folder container_name local_folder"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

mkdir -p $LOCAL_FOLDER

# Download the data in batches
az storage blob download-batch --destination $LOCAL_FOLDER  --source $CONTAINER_NAME --pattern $REMOTE_FOLDER/* 

