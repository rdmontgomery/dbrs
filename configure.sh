#!/bin/bash

sudo yum update
sudo yum -y install git
sudo yum -y install vim
sudo yum -y install python3 python3-pip python3-dev
sudo -H pip3 install jupyter

mkdir ~/.jupyter
echo "c.NotebookApp.allow_origin = '*' c.NotebookApp.ip = '0.0.0.0'" | sudo tee /home/ubuntu/.jupyter/jupyter_notebook_config.py

