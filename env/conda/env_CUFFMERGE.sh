#!/usr/bin/env bash

#------------- Take as 1st parameter the name of your new environment--------------------
env=$1
#----------------------------------------

#------------- Create conda env from yml--------------------
#conda env create -f env.yml
#----------------------------------------

#------------- My env--------------------
# Create environment
conda create -n $env -c bioconda cufflinks=2.2.1
