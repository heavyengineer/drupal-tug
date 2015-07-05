#!/bin/bash
if [ $DEBUG -eq 1 ];then
me="install_from_scratch.sh"
echo ">>>>>>>>executing $me"
fi

##############################################
#######     Install from scratch
##############################################

echo "installing site from scratch"

source ./build_scripts/backup_src_dir.sh

############################################
#####   Download Drupal
############################################

source ./build_scripts/download_drupal.sh

###########################################
##### Move the settings files
###########################################

echo "moving settings"

source ./build_scripts/move_settings.sh

###########################################
##### Install drupal on the docker container
##########################################

# this command also needs the correct drupal version, else it just downloads the most recent
#echo "Drupal Version == $drupal_version"
#echo "Apache Root == $apache_root"

#if [ "$drupal_version" ];then
#echo "drupal_version is set to $drupal_version so we will try and get that version"

###########################
####### copy a working settings file
###########################

# @TODO move the settings file to somewhere obvious
#cp dockers/apache/drupal_docker_settings.php ./src/docroot/sites/default/settings.php

#fi

#########################
#### run site install on the apache-server container
########################
echo "running site install on the apache-server"

#$vagrant_apache_docker_run  -- $drush_site_install
$vagrant_apache_docker_exec  -- $drush_site_install
