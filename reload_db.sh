#!/bin/bash

source ./config/env_variables.config
source ./config/drupal_variables.config
source ./config/vagrant_commands.config

#reloads the db
echo "loading db"

# load the db using drush for better error reporting and reliability etc
$vagrant_apache_docker_run  -- $drush_create_db
$vagrant_apache_docker_run  -- $drush_restore_db

