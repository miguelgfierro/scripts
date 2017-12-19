# This python script allows to download all the files inside a folder from Azure Data Lake Storage.
#
# Usage:
# python adls_download_folder_with_files.py --account-name account_name --adls-folder /temp --local-folder C:\temp
#
# More info here: https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-get-started-python
# Install: pip install azure-datalake-store
#

import argparse
from azure.datalake.store import core, lib, multithread
import time
import multiprocessing


def parse():
    """Parser"""
    parser = argparse.ArgumentParser(description="ADLS file I/O")
    parser.add_argument('--account-name', type=str, help='ADLS account name')
    parser.add_argument('--adls-folder', type=str, help='ADLS folder')
    parser.add_argument('--local-folder', type=str, help='Local folder')
    args = parser.parse_args()
    return args


def client(args):
    """Create a filesystem client object
    Parameters:
        args (class): Arguments.
    """
    adls_client = core.AzureDLFileSystem(store_name=args.account_name)
    return adls_client


if __name__ == "__main__":
    args = parse()
    adls_client = client(args)
    print("Downloading content from ADLS account: {}".format(args.account_name))
    print("Downloading {0} into {1}...".format(args.adls_folder, args.local_folder))
    threads = multiprocessing.cpu_count()
    start_time = time.time()
    multithread.ADLDownloader(adls_client, lpath=args.local_folder, rpath=args.adls_folder, nthreads=threads,
                                  overwrite=True, buffersize=4194304, blocksize=4194304, verbose=True)
    print()
    print("Process time {} seconds".format(time.time() - start_time))
