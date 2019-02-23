#!/bin/bash
#
# This bash script allows to upload a folder to Azure Blob Storage.
#
# Usage:
# sh azure_blob_upload_folder_with_files.sh account_name account_key local_folder container_name remote_folder
# Example:
# sh azure_blob_upload_folder_with_files.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/data tmp_container data
# Example for uploading files to the root of a container
# sh azure_blob_upload_folder_with_files.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/data tmp_container /
#
# More info here: https://docs.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-upload-batch
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
LOCAL_FOLDER=$3
CONTAINER_NAME=$4
REMOTE_FOLDER=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR: Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_blob_upload_folder_with_files.sh account_name account_key local_folder container_name remote_folder"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

# If the container does not exist, it creates one
az storage container create -n $CONTAINER_NAME

# Upload the data in batches
az storage blob upload-batch --destination $CONTAINER_NAME/$REMOTE_FOLDER --source $LOCAL_FOLDER  

