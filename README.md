[![Linkedin](https://img.shields.io/badge/Linkedin-Follow%20Miguel-blue?logo=linkedin)](https://www.linkedin.com/comm/mynetwork/discovery-see-all?usecase=PEOPLE_FOLLOWS&followMember=miguelgfierro)
[![Blog](https://img.shields.io/badge/Blog-Visit%20miguelgfierro.com-blue.svg)](https://miguelgfierro.com?utm_source=github&utm_medium=profile&utm_campaign=scripts)

# A collection of useful scripts for Linux, Windows & Mac.

## Utilities for command line in Linux and Mac

* [git_configure.sh](git_configure.sh): Configure options in git such as alias, user name, email and credential helper.
* [git_update_repos.sh](git_update_repos.sh): It iteratively updates several git repositories for a user.
* [git_status_repos.sh](git_status_repos.sh): It iteratively finds the status of several git repositories for a user. 
* [git_find_big.sh](git_find_big.sh): List git objects ordered by size.
* [jupyter_configure.sh](jupyter_configure.sh): Set up jupyter notebook environment in a Ubuntu server.
* [setup_bashrc.sh](setup_bashrc.sh): Set up several functions to .bashrc like cs (a combination of cd+ls), ccat (cat with color) or reimplement evince to run in background.
* [setup_vim.sh](setup_vim.sh): Set up functions for vim such as the line numbers

## Utilities for Azure

* [adls_download_folder_with_files.ps1](adls_download_folder_with_files.ps1): Powershell script to download a folder with multiple files to ADLS.
* [adls_download_folder_with_files.py](adls_download_folder_with_files.py): Python script to download a folder with multiple files to ADLS.
* [alds_download_single_file.ps1](alds_download_single_file.ps1): Powershell script to download a file to ADLS.
* [adls_download_single_file.sh](adls_download_single_file.sh): Bash script to download a file from Azure DataLake Storage (ADLS). 
* [adls_upload_folder_with_files.ps1](adls_upload_folder_with_files.ps1): Powershell script to upload a folder with multiple files to ADLS.
* [adls_upload_folder_with_files.py](adls_upload_folder_with_files.py): Python script to upload a folder with multiple files to ADLS.
* [adls_upload_single_file.ps1](adls_upload_single_file.ps1): Powershell script to upload a file to ADLS.
* [azure_blob_download_folder_with_files.sh](azure_blob_download_folder_with_files.sh): Bash script to download a folder from Azure Storage Blob.
* [azure_blob_download_single_file.sh](azure_blob_download_single_file.sh): Bash script to download a single file from Azure Storage Blob.
* [azure_blob_upload_folder_with_files.sh](azure_blob_upload_folder_with_files.sh): Bash script to upload a folder to Azure Storage Blob. 
* [azure_blob_upload_single_file.sh](azure_blob_upload_single_file.sh): Bash script to upload a single file to Azure Storage Blob.
* [mount_azure_fileshare.cmd](mount_azure_fileshare.cmd): Windows executable to mount an Azure Fileshare.
* [mount_azure_fileshare.sh](mount_azure_fileshare.sh): Bash script to mount an Azure Fileshare.
* [mount_external_disk.sh](mount_external_disk.sh): Bash script to automatically mount an external Azure disk.
* [vmss_deploy_with_public_ip.py](vmss_deploy_with_public_ip.py): deploys Azure VMSS (Virtual Machine Scale Set), and run [vm_user_env_setup.sh](vm_user_env_setup.sh) on each VM instance to clone a repository, install conda environment and create multiple JupyterHub users.

## Utilities for installing software

* [header_creator.sh](header_creator.sh): A simple shell to add headers (like copyright statements) in files.
* [make_cmake_project.sh](make_cmake_project.sh): A simple shell script for generating C++ projects with CMake. It generates the CMakeList.txt, Doxigen files, folder structure and initial filenames.
* [rstudio_server_install.sh](rstudio_server_install.sh): Installs RStudio Server in an Azure HDI cluster.
* [start_ubuntu.sh](start_ubuntu.sh): Installation of many packages in a fresh Ubuntu.
* [start_gpu_ubuntu.sh](start_gpu_ubuntu.sh): Installation of many packages for a GPU Ubuntu. 

## Misc
* [bing_images_downloader.py](bing_images_downloader.py): A script to download images from Bing.
