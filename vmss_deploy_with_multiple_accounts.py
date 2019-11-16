# This python script deploys Azure VMSS (Virtual Machine Scale Set) with
# multiple JupyterHub user accounts on each VM instance.
#
# Requirements:
# Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
# ```
# az login
# az account set -s {your-azure-subscription-id}
# ```
#
# Usage:
# python vmss_deploy_with_multiple_accounts.py \
#     --name {your-resource-group-name} --location {location} \
#     --vm-sku {your-vm-size} --instance-count {number-of-vms-to-create} \
#     --admin-id {vm-admin-id} --admin-pw {vm-admin-pw} \
#     --user-id {vm-user-id} --user-pw {vm-user-pw} --user-count {number-of-users-per-vm} \
#     --post-script {post-deployment-script-to-run-on-each-vm}
#
# Authors:
# Jun Ki Min (https://github.com/loomlike)
# JS Tan (https://github.com/jiata)

import argparse
import subprocess


def get_ips(rg_name, vmss_name):
    """Get public IPs of all VMs in VMSS
    Args:
        rg_name (str): Resource group name
        vmss_name (str): VMSS name
    """

    cmd = "az vmss list-instance-public-ips --resource-group {} --name {} | grep ipAddress".format(rg_name, vmss_name)

    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    if len(error) > 0:
        raise RuntimeError(error)
    print(output)


def parse():
    """Parser"""
    parser = argparse.ArgumentParser(description="Deploy VMSS with multiple user accounts")
    parser.add_argument('--name', type=str, help="Resource-group name to create")
    parser.add_argument('--location', type=str, help="Location to deploy resources (e.g. 'eastus')")
    parser.add_argument('--vm-sku', type=str, help="VM size (e.g. 'Standard_NC6s_v3')")
    parser.add_argument('--vm-count', type=int, help="Number of VMs to create")
    parser.add_argument('--admin-id', type=str, help="Admin user id for all VMs")
    parser.add_argument('--admin-pw', type=str, help="Admin user pw for all VMs")
    parser.add_argument('--user-id', type=str, default="user",
                        help="VM user id prefix. The actual id for N-th user of each VM will be 'prefixN'")
    parser.add_argument('--user-pw', type=str, default="password",
                        help="VM user pw prefix. The actual pw for N-th user of each VM will be 'prefixN'")
    parser.add_argument('--user-count', type=int, help="Number of users to create")
    parser.add_argument('--post-script', type=str, help="Post deployment script to run on each VM")
    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = parse()

    RG_NAME = args.name
    VMSS_NAME = "{}-vmss".format(RG_NAME)

    get_ips(RG_NAME, RG_NAME)
    # LOCATION = "your-resource-location"  # e.g. australiaeast
    # VM_SIZE = "your-vm-size"  # e.g. Standard_NC6s_v3
    #
    #
    #
    # # Number of VM instances in a scale set
    # NUM_VM = 40
    #
    # !az
    # group
    # create - -name
    # {RG_NAME} - -location
    # {LOCATION}
    #
    # # Setup public-ip for each vm by using `--public-ip-per-vm` parameter
    # !az
    # vmss
    # create - g
    # {RG_NAME} - n
    # {VMSS_NAME} - -instance - count
    # {NUM_VM} - -image
    # microsoft - dsvm:linux - data - science - vm - ubuntu:linuxdsvmubuntu:latest - -vm - sku
    # {VM_SIZE} - -public - ip - per - vm - -admin - username
    # jiata - -admin - password
    # cvbpMlads2019

