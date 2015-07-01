#!/bin/bash
# build drupal software from source and load db
me="load_db.sh"
echo ">>>>>>>>executing $me"


# load vars from the config file to prevent errant changes in here
source ./config/env_variables.config
source ./config/drupal_variables.config
source ./config/vagrant_commands.config

# if the $db_url is null
if [ -z "$db_url" ]; then
echo "db_url is not set so we will attempt to load the database from scratch"

else

# load the db
echo "loading db from $db_url"

# load the db using drush for better error reporting and reliability etc
$vagrant_apache_docker_run  -- $drush_create_db
$vagrant_apache_docker_exec  -- $drush_restore_db
fi
