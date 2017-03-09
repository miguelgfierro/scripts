# This Powershell script allows to upload all the files inside a folder to Azure Data Lake Storage.
#
# Usage:
# .\adls_upload_folder_with_files.ps1 "account_name" "local_folder" "adls_folder" 
# Example:
# .\adls_upload_folder_with_files.ps1 "adls_account1" "C:\temp" "/temp" 
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-analytics-get-started-powershell/
# 

#Parameters
Login-AzureRmAccount
$dataLakeStoreName = $args[0]
$localFolder = $args[1]
$adlsFolder = $args[2]

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
Write-Output "Uploading content to ADLS account: $dataLakeStoreName"
$files = Get-ChildItem -Path $localFolder -Recurse 
for ($i=0; $i -lt $files.Count; $i++) {
	$content = $files[$i].FullName
	$content_cleaned = $content.Replace($localFolder + "\","")
	$content_adls = $content_cleaned.Replace("\","/")
	if(Test-Path $content -PathType Container){
		Write-Output "Creating folder: $content_adls" 
		New-AzureRmDataLakeStoreItem -Folder -AccountName $dataLakeStoreName -Path $adlsFolder/$content_adls -Force
	}
	else{
		Write-Output "Uploading: $content_adls"
		Import-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $content -Destination $adlsFolder/$content_adls -Force
	}
}
$sw.Stop()
$time = $sw.Elapsed
$formatTime = FormatElapsedTime $time
Write-Host "Process time: $formatTime"
