#!/bin/bash
if [ $DEBUG -eq 1 ];then
echo ">>>>>>>> executing install_existing_site"
fi

echo "scratch is not set so we will install an existing site"

source ./build_scripts/clone_repo.sh
source ./build_scripts/load_db.sh
source ./build_scripts/copy_db.sh
# if not installing from scratch then the settings file will need some manipulation
# this needs some thinkng but easiest right now is to replace the existing settings.php
# with one that works with the docker containers.  probably a good idea will be to rebuild
# the settings.php - wrt the drupal hash, then this should maybe only be stored on production
# anyway there is no need for a developer to have access to the salt

source ./build_scripts/move_settings.sh

