#!/bin/bash

sudo yum -y update
sudo yum -y install git

# Grab source code from Github
git clone https://github.com/rdmontgomery/nycOpenData.git
cd nycOpenData

# Run dockerized jupyter notebook with a specified token
# and volume connected to current directory
docker run -d --name jupyter --rm -v /$PWD:/home/jovyan/work/ -p 8888:8888 jupyter/datascience-notebook start-notebook.sh --NotebookApp.token="transvertercorrelativenessechoismssinfoniettas"

