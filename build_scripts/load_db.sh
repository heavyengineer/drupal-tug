#!/bin/bash
# build drupal software from source and load db

# load vars from the config file to prevent errant changes in here
source ./env_variables.config
source ./drupal_variables.config
source ./vagrant_commands.config

# if the $db_url is null
if [ -z "$db_url" ]; then
echo "db_url is not set so we will attempt to load the database from scratch"

# in this instance the user wants to load the db from scratch (and prob configure
# the site using .install updates() and using code in a repo rather than a base install
# install the site from scratch
$vagrant_apache_docker_run  -- $drush_site_install
else

# load the db
echo "loading db from $db_url"

# load the db using drush for better error reporting and reliability etc
$vagrant_apache_docker_run  -- $drush_create_db
$vagrant_apache_docker_run  -- $drush_restore_db
fi
