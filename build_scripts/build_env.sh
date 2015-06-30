#!/bin/bash

source ./build_scripts/check_install.sh

echo "Building vagrant stuff"
vagrant up --provider=docker --no-parallel

echo "Build local development environment"

# source the db file to make it available to vagrant + Docker
#source copy_db.sh

# do drupal build here
#./build_scripts/build_drupal.sh
