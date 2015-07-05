#!/bin/bash
if [ $DEBUG -eq 1 ];then
me=`basename "$0"`
echo "executing $me"
fi

source ./build_scripts/check_install.sh

echo "Building vagrant stuff"
vagrant up --provider=docker --no-parallel

echo "Build local development environment"

# source the db file to make it available to vagrant + Docker
#source ./build_scripts/copy_db.sh

# do drupal build here
source ./build_scripts/build_drupal.sh
