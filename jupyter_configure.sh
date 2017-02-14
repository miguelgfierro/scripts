#!/bin/bash
#
# This script configure jupyter notebook in an ubuntu server
# Info here: https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-jupyter-notebook/
# To activate an environment in the notebook: http://stackoverflow.com/a/37857536/5620182
#

JUPYTER_HOME=~/.jupyter
JUPYTER_CONF=jupyter_notebook_config.py

if which jupyter-notebook >/dev/null; then
    echo "Jupyter notebook exists, in the following location:"
    ls -lha `which jupyter-notebook`
    jupyter-notebook --generate-config
    cd $JUPYTER_HOME
    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.pem -out mycert.pem
    echo "Enter password for Jupyter notebook"
    python -c "import IPython;print(IPython.lib.passwd())" > SHA1_FILE
    SHA1=$(cat SHA1_FILE)
	sed -i "s|#c.NotebookApp.certfile = ''|c.NotebookApp.certfile = '$JUPYTER_HOME/mycert.pem'|" $JUPYTER_CONF
	sed -i "s|#c.NotebookApp.ip = 'localhost'|c.NotebookApp.ip = '*'|" $JUPYTER_CONF
	sed -i "s|#c.NotebookApp.open_browser = True|c.NotebookApp.open_browser = False|" $JUPYTER_CONF	
	sed -i "s|#c.NotebookApp.keyfile = ''|c.NotebookApp.keyfile = '$JUPYTER_HOME/mykey.pem'|" $JUPYTER_CONF
	sed -i "s|#c.NotebookApp.port = 8888|c.NotebookApp.port = 8888|" $JUPYTER_CONF	
	sed -i "s|#c.NotebookApp.password = ''|c.NotebookApp.password = '$SHA1'|" $JUPYTER_CONF
	echo "Process finished"
	echo "If you are in Azure, remember to open the port 8888 in the virtual machine's network security group. It can be accesed via Inbound security rules"
	cd
else
    echo "Jupyter notebook does not exist, please install"
    echo "We recommend to install Anaconda. It can be downloaded for linux in the following link: https://www.continuum.io/downloads#linux"
    exit
fi


