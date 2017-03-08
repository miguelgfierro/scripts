# This Powershell script allows to download all the files inside a folder from Azure Data Lake Storage.
#
# Usage:
# .\adls_download_folder_with_files.ps1 "account_name" "adls_folder" "local_folder"  
# Example:
# .\adls_download_folder_with_files.ps1 "adls_account1" "/temp/" "C:\temp\"  
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-analytics-get-started-powershell/
# 

#Parameters
Login-AzureRmAccount
$dataLakeStoreName = $args[0]
$adlsFolder = $args[1]
$localFolder = $args[2]

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
Write-Output "Downloading content from ADLS account: $dataLakeStoreName"
$files = Get-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $adlsFolder
foreach ($it in $files){
    $content = $it.Name
    Export-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $adlsFolder$content -Destination $localFolder$content -Force -Recurse
}
$sw.Stop()
$time = $sw.Elapsed
$formatTime = FormatElapsedTime $time
Write-Host "Process time: $formatTime"
