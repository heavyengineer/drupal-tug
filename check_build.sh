#!/bin/bash
# runs some basic tests and outputs results
echo "Checking the status of the build"

# use the defaults from the build script
source ./env_variables.config
source ./drupal_variables.config

echo "Is filesystem mounted in apache-server ok?"
$vagrant_apache_docker_run -- $drush status

echo "What do default/files permissions look like?"
$vagrant_apache_docker_run -- ls -ld /vagrant/src/docroot/sites/default/files
