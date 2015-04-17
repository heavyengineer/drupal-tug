#!/bin/bash

echo "Building vagrant stuff"
vagrant up --provider=docker --no-parallel 

echo "Build local development environment"
# do drupal build here
./build_drupal.sh
