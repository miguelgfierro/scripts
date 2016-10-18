# This Powershell script allows to upload a file to Azure Data Lake Storage.
#
# Usage:
# .\upload_file_adls.ps1 "account_name" "local_folder" "file_name" "adls_folder" 
# Example:
# .\upload_files_adls.ps1 "adls_account1" "C:\temp\" "test.csv" "/temp/" 
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-analytics-get-started-powershell/
#

Login-AzureRmAccount

$dataLakeStoreName = $args[0]
$localFolder = $args[1]
$fileName = $args[2]
$adlsFolder = $args[3]

Import-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $localFolder$fileName -Destination $adlsFolder$fileName