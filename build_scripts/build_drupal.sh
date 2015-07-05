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

source ./build_scripts/install_existing_site.sh

else

echo "Installing from scratch"

##############################################
#######     Install from scratch
##############################################

source ./build_scripts/install_from_scratch.sh
#source ./build_scripts/local_post_install.sh
fi
