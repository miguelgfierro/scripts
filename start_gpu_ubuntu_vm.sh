#! /bin/bash

# Installation of several packages in an Azure GPU VM. Based on this blog:
# https://blogs.technet.microsoft.com/machinelearning/2016/09/15/building-deep-neural-networks-in-the-cloud-with-azure-gpu-vms-mxnet-and-microsoft-r-server/
#
# To run this script first you have to fill up several external files
# cp resources_template.txt resources.txt
#

###################################
# Update and Upgrade
###################################
echo
echo "Updating and upgrading..."
echo
sudo apt-get update && sudo apt-get upgrade -y

###################################
# Add external resources 
###################################
echo
echo "Adding external resources to the environment..."
echo
#source resources.txt
CUDA_INSTALLER=cuda_8.0.27_linux.run
CUDA_PATCH=cuda_8.0.27.1_linux.run
CUDNN_INSTALLER=cudnn-8.0-linux-x64-v5.1.tgz
MKL_INSTALLER=l_mkl_11.3.3.210.tgz
RSERVER_INSTALLER=en_microsoft_r_server_for_linux_x64_8944657.tar.gz
MXNET_VERSION=450141c5293b332948e5c403c689b64f4ce22efd

###################################
# Installations
###################################
echo
echo "Installing programs..."
echo

### compilers and IDEs
sudo apt-get install build-essential cmake cmake-curses-gui gfortran  pkg-config -y
### libraries
sudo apt-get install libboost-all-dev libeigen3-dev libblas-dev liblapack-dev libprotoc-dev -y
### python
sudo apt-get install python-numpy python-tk python-matplotlib python-pip  -y
sudo pip install jupyter jinja2 tornado pyzmq scipy scikit-image wget
### repositories and connections
sudo apt-get install git ssh openssh-server libcurl4-openssl-dev libssl-dev -y
### tools
sudo apt-get install p7zip-rar htop mencoder -y
### opencv
sudo apt-get install libopencv-dev -y
### azure client
sudo apt-get install nodejs-legacy -y
sudo apt-get install npm -y
sudo npm install -g azure-cli
azure --completion >> ~/.azure.completion.sh
echo 'source ~/.azure.completion.sh' >> ~/.bashrc
azure telemetry --disable
azure config mode asm

###################################
# Cleaning
###################################
echo
echo "Cleaning..."
echo
sudo apt-get autoclean

###################################
# Configuring
###################################
echo
echo "Configuring..."
echo
### gcc
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 50

###################################
# GPU drivers, CUDA and CuDNN
###################################
# CUDA can be downloaded: https://developer.nvidia.com/cuda-toolkit
# CuDNN can be downloaded: https://developer.nvidia.com/cudnn
echo
echo "Installing CUDA and CuDNN..."
echo

### CUDA
INSTALL_FOLDER=installer
cd ~$INSTALL_FOLDER
chmod 755 $CUDA_INSTALLER 
sh $CUDA_INSTALLER --silent --driver --toolkit --override --verbose 
if CUDA_PATCH:
if [ -z "$CUDA_PATCH" ]
then
	echo "Adding the patch"
	sh $CUDA_PATCH --silent --accept-eula 
fi
### CuDNN
tar xvzf $CUDNN_INSTALLER
mv cuda /usr/local/cudnn
ln -s /usr/local/cudnn/include/cudnn.h /usr/local/cuda/include/cudnn.h
sudo update-alternatives --install /usr/bin/nvcc nvcc /usr/bin/gcc 50

###################################
# Math Kernel Library (MKL)
###################################
# MKL can be downloaded: https://software.intel.com/en-us/intel-mkl
MKL_NAME=l_mkl_11.3.3.210 # TODO: automatize this
tar xvzf $MKL_INSTALLER 
#TODO: change options of silent.cfg with sed
sh $MKL_NAME/install.sh --silent $MKL_NAME/silent.cfg
ln -s /opt/intel/compilers_and_libraries_2016.3.210/linux/compiler/lib/intel64_lin/libiomp5.so /lib/libiomp5.so

###################################
# RServer
###################################
# R Server can be downloaded: https://www.microsoft.com/en/server-cloud/products/r-server/default.aspx
echo
echo "Installing Microsoft R Server"
echo

### R Server
RSERVER_FOLDER=r_server
tar -xvzf $RSERVER_INSTALLER 
sh $RSERVER_FOLDER/install.sh -s -a
mv /usr/lib64/microsoft-r/8.0/lib64/R/deps/libstdc++.so.6 /tmp
mv /usr/lib64/microsoft-r/8.0/lib64/R/deps/libgomp.so.1 /tmp
echo "
/usr/local/cuda/lib64/
/usr/local/cudnn/lib64/" >> /etc/ld.so.conf
ldconfig

### R packages
Rscript -e "install.packages('devtools', repo = 'https://cran.rstudio.com')"
Rscript -e "install.packages(c('scales','knitr','mlbench','zoo','roxygen2','stringr','DiagrammeR','data.table','ggplot2','plyr','manipulate','colorspace','reshape2','digest','RColorBrewer','readbitmap','argparse','png','jpeg','readbitmap'), dependencies = TRUE)"
wget https://cran.r-project.org/src/contrib/Archive/imager/imager_0.20.tar.gz
R CMD INSTALL imager_0.20.tar.gz


###################################
# Deep learning libraries
###################################
echo
echo "Installing deep learning libraries"
echo 

### MXNet
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
sudo R CMD INSTALL mxnet_0.7.tar.gz
### MXNet python package
cd python
sed -i "s|'numpy',|# 'numpy',|" setup.py
python setup.py install
PYTHONPATH=$INSTALL_FOLDER/mxnet/python:$PYTHONPATH
echo "export PYTHONPATH=$PYTHONPATH" >> ~/.bashrc
cd ..

###################################
# Finish!
###################################
echo
echo "Finish! All done!"
echo
