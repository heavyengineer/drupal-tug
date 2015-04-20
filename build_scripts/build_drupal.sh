#!/bin/bash
# build drupal software from source and load db

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

else

echo "scratch is set to $scratch so we will install from scratch"

##############################################
#######     Install from scratch
##############################################

source ./build_scripts/install_from_scratch.sh
#source ./build_scripts/local_post_install.sh
fi
