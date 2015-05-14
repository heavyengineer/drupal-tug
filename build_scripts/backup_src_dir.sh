#!/bin/bash

##############################################
#######    backup the src directory if it exists 
##############################################

echo "backing up the src directory"

# Make a backup copy of src dir if exists
if [ -d ./src ]; then
echo "./src exists so backing it up now"
cp -r src src.`date +"%T"`bak
echo "removing existing src directory for new installation"
rm -rf ./src
fi

# create a new empty src directory
echo "creating a new ./src directory"
mkdir ./src
