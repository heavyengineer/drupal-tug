#!/bin/bash

source ./build_scripts/check_install.sh

echo "Building vagrant stuff"
vagrant up --provider=docker --no-parallel

echo "Build local development environment"

# do drupal build here
./build_scripts/build_drupal.sh
