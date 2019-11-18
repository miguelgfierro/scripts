#!/bin/bash

# An example shell script to clone a repository, install conda environment,
# and create multiple JupyterHub users
#
# Authors:
# Jun Ki Min (https://github.com/loomlike)
# JS Tan (https://github.com/jiata)

cd ~

# clone repo and install the conda env
git clone https://www.github.com/microsoft/computervision
# change permission as we copy this into each user's folder
chmod -R ugo+rwx /root/computervision

source /data/anaconda/etc/profile.d/conda.sh
conda env create -f /root/computervision/environment.yml --name cv
conda activate cv
python -m ipykernel install --name cv

# add 5 users to jupyterhub
echo 'c.Authenticator.whitelist = {"user1", "user2", "user3", "user4", "user5"}' | sudo tee -a /etc/jupyterhub/jupyterhub_config.py

# create the users on the vm
for i in {1..5}
do
    USERNAME=user$i
    PASSWORD=password$i
    sudo adduser --quiet --disabled-password --gecos "" $USERNAME
    echo "$USERNAME:$PASSWORD" | sudo chpasswd
    rm -rf /data/home/$USERNAME/notebooks/*
    # copy repo
    cp -ar /root/computervision /data/home/$USERNAME/notebooks
done

# restart jupyterhub
sudo systemctl stop jupyterhub
sudo systemctl start jupyterhub

exit
