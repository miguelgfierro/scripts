#!/bin/bash
#
# This script configure jupyter notebook in an ubuntu server
# Info here: https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-jupyter-notebook/
#

JUPYTER_HOME=~/.jupyter
JUPYTER_CONF=jupyter_notebook_config.py

if which jupyter-notebook >/dev/null; then
    echo "Jupyter notebook exists, in the following location:"
    ls -lha `which jupyter-notebook`
    jupyter-notebook --generate-config
    cd $JUPYTER_HOME
    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
    python -c "import IPython;print(IPython.lib.passwd())" > SHA1
	sed -i "s|# c.NotebookApp.certfile = ''|c.NotebookApp.certfile = '\$JUPYTER_HOME/mycert.pem'|" $JUPYTER_CONF
	sed -i "s|# c.NotebookApp.ip = '*'|c.NotebookApp.ip = '*'|" $JUPYTER_CONF
	sed -i "s|# c.NotebookApp.keyfile = ''|c.NotebookApp.keyfile = '\$JUPYTER_HOME/mykey.pem'|" $JUPYTER_CONF
	sed -i "s|# c.NotebookApp.password = ''|c.NotebookApp.password = '\$SHA1'|" $JUPYTER_CONF
	sed -i "s|# c.NotebookApp.port = 8888 |c.NotebookApp.port = 8888|" $JUPYTER_CONF	
	cd
else
    echo "Jupyter notebook does not exist, please install"
fi