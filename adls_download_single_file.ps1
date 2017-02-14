# This Powershell script allows to download a file from Azure Data Lake Storage.
#
# Usage:
# .\adls_download_single_file.ps1 "account_name" "adls_folder" "file_name" "local_folder"
# Example:
# .\adls_download_single_file.ps1 "adls_account1" "/temp/" "test.csv" "C:\temp\" 
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-analytics-get-started-powershell/
#

Login-AzureRmAccount

$dataLakeStoreName = $args[0]
$localFolder = $args[1]
$fileName = $args[2]
$adlsFolder = $args[3]

Export-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $adlsFolder$fileName -Destination $localFolder$fileName -Force
