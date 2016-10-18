#!/bin/bash
#
# This script configure jupyter notebook in an ubuntu server
#

if which jupyter-notebook >/dev/null; then
    echo "Jupyter notebook exists, in the following location:"
    ls -lha `which jupyter-notebook`
    
else
    echo "Jupyter notebook does not exist, please install"
fi