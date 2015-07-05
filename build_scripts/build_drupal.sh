#!/bin/bash
# build drupal software from source and load db
if [ $DEBUG -eq 1 ];then
me="build_drupal.sh"
echo ">>>>>>>>executing $me"
fi

# load vars from the config file to prevent errant changes in here
source ./config/env_variables.config
source ./config/drupal_variables.config
source ./config/vagrant_commands.config

######## site building starts here #########
######## for the local src #################

echo "building site for $client_name"

# if $scratch isn't set then download the repo
if [ -z "$scratch" ];then

echo "scratch is not set so we will download the repo from the repo_url"

source ./build_scripts/clone_repo.sh
source ./build_scripts/load_db.sh
source ./build_scripts/copy_db.sh
# if not installing from scratch then the settings file will need some manipulation
# this needs some thinkng but easiest right now is to replace the existing settings.php
# with one that works with the docker containers.  probably a good idea will be to rebuild
# the settings.php - wrt the drupal hash, then this should maybe only be stored on production
# anyway there is no need for a developer to have access to the salt

source ./build_scripts/move_settings.sh


else

echo "scratch is set to $scratch so we will install from scratch"

##############################################
#######     Install from scratch
##############################################

source ./build_scripts/install_from_scratch.sh
#source ./build_scripts/local_post_install.sh
fi
