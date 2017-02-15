# This Powershell script allows to download a file from Azure Data Lake Storage.
#
# Usage:
# .\adls_download_single_file.ps1 "account_name" "adls_folder" "file_name" "local_folder"
# Example:
# .\adls_download_single_file.ps1 "adls_account1" "/temp/" "test.csv" "C:\temp\" 
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-analytics-get-started-powershell/
#

#Parameters
Login-AzureRmAccount
$dataLakeStoreName = $args[0]
$adlsFolder = $args[1]
$fileName = $args[2]
$localFolder = $args[3]

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
Export-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $adlsFolder$fileName -Destination $localFolder$fileName -Force
$sw.Stop()
$time = $sw.Elapsed
$formatTime = FormatElapsedTime $time
Write-Host "Process time: $formatTime"
