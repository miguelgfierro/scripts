:: This script allows for mounting a fileshare storage in a linux VM. 
:: Before executing dist you have to create a fileshare in your storage account. For that go to https://ms.portal.azure.com,
:: select your storage, under Services press Files, create a File Share with a name and a size (max. 5Tb). The name you 
:: chose is FILESHARE_NAME in this script.  
::
:: WARNING: The VM and the storage has to be in the same region!
::
:: More info here: https://docs.microsoft.com/en-us/azure/storage/storage-dotnet-how-to-use-files
::

SET STORAGE_NAME=storage_name
SET STORAGE_KEY=storage_key
SET FILESHARE_NAME=fileshare_name
SET MOUNT_POINT=W:

ECHO Mounting fileshare %FILESHARE_NAME% from storage %STORAGE_NAME%
net use %MOUNT_POINT% \\%STORAGE_NAME%.file.core.windows.net\%FILESHARE_NAME% /u:AZURE\%STORAGE_NAME% %STORAGE_KEY% /PERSISTENT:NO
