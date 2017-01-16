#!/bin/bash
#
# This bash script allows to download a file from Azure Data Lake Storage.
# Usage:
# $ sh adls_download_single_file.sh account_name adls_folder file_name local_folder
#
# Example:
# $ sh adls_download_single_file.sh adls_account1 /temp test.csv /home/myusername/
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-store-get-started-cli/#rename-download-and-delete-data-from-your-data-lake-store
#
DATA_LAKE_STORE_NAME=$1
ADLS_FOLDER=$2
FILE_NAME=$3
LOCAL_FOLDER=$4

if [ "$#" -ne 4 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh adls_download_single_file.sh adls_account1 /temp test.csv /home/myusername/"
  exit 1
fi

azure login
azure config mode arm
azure datalake store filesystem export --force $DATA_LAKE_STORE_NAME $ADLS_FOLDER/$FILE_NAME $LOCAL_FOLDER/$FILE_NAME

