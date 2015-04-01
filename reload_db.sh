#!/bin/bash
source ./env_variables.config
source ./drupal_variables.config

#reloads the db
echo "loading db"

# load the db using drush for better error reporting and reliability etc
$vagrant_apache_docker_run  -- $drush_create_db
$vagrant_apache_docker_run  -- $drush_restore_db

source ./local_post_install.sh
