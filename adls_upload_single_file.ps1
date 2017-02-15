# This Powershell script allows to upload a file to Azure Data Lake Storage.
#
# Usage:
# .\adls_upload_single_file.ps1 "account_name" "local_folder" "file_name" "adls_folder" 
# Example:
# .\adls_upload_single_file.ps1 "adls_account1" "C:\temp\" "test.csv" "/temp/" 
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-analytics-get-started-powershell/
#

#Parameters
Login-AzureRmAccount
$dataLakeStoreName = $args[0]
$localFolder = $args[1]
$fileName = $args[2]
$adlsFolder = $args[3]

#Timer function
Function FormatElapsedTime($ts) {
    $elapsedTime = ""
    if ( $ts.Minutes -gt 0 ){
        $elapsedTime = [string]::Format( "{0:00} min. {1:00}.{2:00} sec.", $ts.Minutes, $ts.Seconds, $ts.Milliseconds / 10 );
    }
    else{
        $elapsedTime = [string]::Format( "{0:00}.{1:00} sec.", $ts.Seconds, $ts.Milliseconds / 10 );
    }
    if ($ts.Hours -eq 0 -and $ts.Minutes -eq 0 -and $ts.Seconds -eq 0){
        $elapsedTime = [string]::Format("{0:00} ms.", $ts.Milliseconds);
    }
    if ($ts.Milliseconds -eq 0){
        $elapsedTime = [string]::Format("{0} ms", $ts.TotalMilliseconds);
    }
    return $elapsedTime
}

#Main process
$sw = [Diagnostics.Stopwatch]::StartNew()
Import-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $localFolder$fileName -Destination $adlsFolder$fileName -Force
$sw.Stop()
$time = $sw.Elapsed
$formatTime = FormatElapsedTime $time
Write-Host "Process time: $formatTime"