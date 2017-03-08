#! /bin/bash

# Installation of several packages in an Azure GPU VM. Based on this blog:
# https://blogs.technet.microsoft.com/machinelearning/2016/09/15/building-deep-neural-networks-in-the-cloud-with-azure-gpu-vms-mxnet-and-microsoft-r-server/
#
# To attach an external distk in Azure you can follow this guide: https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-add-disk
#

###################################
# Update and Upgrade
###################################
echo
echo "Updating and upgrading..."
echo
apt-get update && apt-get upgrade -y

###################################
# Add external resources 
###################################
echo
echo "Adding external resources to the environment..."
echo
CUDA_INSTALLER=cuda_8.0.27_linux.run
CUDA_PATCH=cuda_8.0.27.1_linux.run
CUDNN_INSTALLER=cudnn-8.0-linux-x64-v5.1.tgz
ANACONDA_INSTALLER=Anaconda3-4.3.0-Linux-x86_64.sh
RSERVER_INSTALLER=microsoft-r-server-mro-8.0
RSTUDIO_INSTALLER=rstudio-server-1.0.136-amd64.deb
MXNET_VERSION=450141c5293b332948e5c403c689b64f4ce22efd
CNTK_VERSION=CNTK-2-0-beta12-0-Linux-64bit-GPU-1bit-SGD.tar.gz
# Installation forlders
INSTALL_FOLDER=$PWD
#get user even if the script was called with sudo
if [ $SUDO_USER ]; then CURRENT_USER=$SUDO_USER; else CURRENT_USER=`whoami`; fi
INSTALL_HOME=/home/$CURRENT_USER

###################################
# Installations
###################################
echo
echo "Installing programs..."
echo

### compilers and IDEs
apt-get install build-essential cmake cmake-curses-gui gfortran  pkg-config -y
### libraries
apt-get install libboost-all-dev libeigen3-dev libblas-dev liblapack-dev libprotoc-dev libfftw3-dev -y
### python
apt-get install python-numpy python-tk python-matplotlib python-pip  -y
pip install jupyter jinja2 tornado pyzmq scipy scikit-image wget setuptools
### repositories and connections
apt-get install git ssh openssh-server libcurl4-openssl-dev libssl-dev -y
### tools
apt-get install p7zip-rar htop mencoder -y
### opencv
apt-get install libopencv-dev python-opencv -y
### azure client
apt-get install nodejs-legacy -y
apt-get install npm -y
npm install -g azure-cli
azure --completion >> $INSTALL_HOME/.azure.completion.sh
echo 'source ~/.azure.completion.sh' >> $INSTALL_HOME/.bashrc
azure telemetry --disable
azure config mode asm

###################################
# Cleaning
###################################
echo
echo "Cleaning..."
echo
apt-get autoclean

###################################
# GPU drivers, CUDA and CuDNN
###################################
# CUDA can be downloaded: https://developer.nvidia.com/cuda-toolkit
# CuDNN can be downloaded: https://developer.nvidia.com/cudnn
echo
echo "Installing CUDA and CuDNN..."
echo

### CUDA
chmod 755 $CUDA_INSTALLER 
sh $CUDA_INSTALLER --silent --driver --toolkit --override --verbose 
if [ -f "$CUDA_PATCH" ]; then
	echo "Adding CUDA patch"
	sh $CUDA_PATCH --silent --accept-eula 
fi
### CuDNN
if [ -f "$CUDNN_INSTALLER" ]; then
	tar xvzf $CUDNN_INSTALLER
	mv cuda /usr/local/cudnn
	ln -s /usr/local/cudnn/include/cudnn.h /usr/local/cuda/include/cudnn.h
fi
###################################
# Anaconda
###################################
echo
echo "Installing Anaconda..."
echo
wget https://repo.continuum.io/archive/$ANACONDA_INSTALLER
bash $ANACONDA_INSTALLER -b -p $INSTALL_HOME/anaconda3
chown -R $CURRENT_USER:$CURRENT_USER $INSTALL_HOME/anaconda3
echo "export PATH=$INSTALL_HOME/anaconda3/bin:\$PATH" >> $INSTALL_HOME/.bashrc

###################################
# RServer
###################################
# R Server can be downloaded: https://www.microsoft.com/en/server-cloud/products/r-server/default.aspx 

echo
echo "Installing Microsoft R Server"
echo

### R Server
sudo apt-get install libpango1.0-0 -y
wget https://mran.revolutionanalytics.com/install/mro4mrs/8.0.5/$RSERVER_INSTALLER.tar.gz
tar -xvzf $RSERVER_INSTALLER.tar.gz
dpkg -i $RSERVER_INSTALLER/$RSERVER_INSTALLER.deb
mv /usr/lib64/microsoft-r/8.0/lib64/R/deps/libstdc++.so.6 /tmp
mv /usr/lib64/microsoft-r/8.0/lib64/R/deps/libgomp.so.1 /tmp

### R Studio can be downloaded: https://www.rstudio.com/products/rstudio/download-server/
apt-get install gdebi-core
wget https://download2.rstudio.org/$RSTUDIO_INSTALLER
gdebi $RSTUDIO_INSTALLER -n

### R packages
ln -s /bin/gzip /usr/bin/gzip

Rscript -e "install.packages('devtools', repo = 'https://cran.rstudio.com')"
Rscript -e "install.packages(c('scales','knitr','mlbench','zoo','roxygen2','stringr','DiagrammeR','data.table','ggplot2','plyr','manipulate','colorspace','reshape2','digest','RColorBrewer','readbitmap','argparse','png','jpeg','readbitmap'), dependencies = TRUE)"


###################################
# Deep learning libraries
###################################
echo
echo "Installing deep learning libraries"
echo 

### MXNet
read -r -p "Do you want to install MXNet? [y/n] " RESP_MNXET
RESP_MNXET=${RESP_MNXET,,}    # tolower
if [[ $RESP_MNXET =~ ^(yes|y)$ ]]
then
	echo "Installing MXNet with checkout $MXNET_VERSION"
	git clone --recursive https://github.com/dmlc/mxnet.git
	cd mxnet
	git checkout $MXNET_VERSION
	cp make/config.mk .
	sed -i "s|USE_BLAS = atlas|USE_BLAS = mkl|" config.mk
	#TODO: set other options
	export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/cudnn/lib64/:$LD_LIBRARY_PATH
	export LIBRARY_PATH=/usr/local/cudnn/lib64/
	make -j${nproc}
	### MXNet R package
	make rpkg
	R CMD INSTALL mxnet_0.7.tar.gz
	### MXNet python package
	cd python
	sed -i "s|'numpy',|# 'numpy',|" setup.py
	python setup.py install
	PYTHONPATH=$INSTALL_FOLDER/mxnet/python:$PYTHONPATH
	echo "export PYTHONPATH=$PYTHONPATH" >> $INSTALL_HOME/.bashrc
	cd ../..
fi

### CNTK
read -r -p "Do you want to install CNTK? [y/n] " RESP_CNTK
RESP_CNTK=${RESP_CNTK,,}    # tolower
if [[ $RESP_CNTK =~ ^(yes|y)$ ]]
then
	echo "Installing CNTK with checkout $CNTK_VERSION"
	wget https://cntk.ai/BinaryDrop/$CNTK_VERSION
	tar -zxvf $CNTK_VERSION
	sh cntk/Scripts/install/linux/install-cntk.sh --py-version 35
fi
###################################
# Finish!
###################################
echo
echo "Finish! All done!"
echo


