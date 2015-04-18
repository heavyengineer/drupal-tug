#!/bin/bash

##############################################
#######     Install from scratch
##############################################

source ./env_variables.config
source ./drupal_variables.config

echo "installing site from scratch"

# Make a backup copy of src dir if exists
if [ -d ./src ]; then
echo "./src exists so backing it up now"
cp -r src src.`date +"%T"`bak
echo "removing existing src directory for new installation"
rm -rf ./src
fi

# create a new empty src directory
echo "creating a new ./src directory"
mkdir ./src

############################################
#####   Install Drupal
############################################

# if a version of drupal has been specified in the env_variables.conf
if [ -n "$drupal_version" ];then

echo "drupal_version var has been declared as $drupal_version so we will attempt to download it"

# Download and explode drupal
drupal_archive=drupal-$drupal_version

# if it's not already downloaded
if [ ! -f ${drupal_archive}.tar.gz ]; then
echo "no existing version of drupal-$drupal_version found, so we will attempt to download a new copy"
curl --silent --output ./$drupal_archive.tar.gz  http://ftp.drupal.org/files/projects/$drupal_archive.tar.gz
fi

# if not already decompressed - decompress
if [ ! -d $drupal_archive ]; then
echo "decompressing $drupal_archive"
# explode into src and rename docroot
#@TODO use the -C switch to remove the need for the mv below
tar -xzf ./$drupal_archive.tar.gz
fi

# create local drupal 
echo "moving $drupal_archive to src/docroot"
mv $drupal_archive src/docroot

fi

###########################################
##### Install drupal on the docker container
##########################################

# install the site from scratch
# this command also needs the correct drupal version, else it just downloads the most recent
# @TODO have this version concur with the drupal version in the vars so it works with xdebug
echo "Drupal Version == $drupal_version"
echo "Apache Root == $apache_root"
if [ "$drupal_version" ];then
echo "drupal_version is set to $drupal_version so we will try and get that version"
fi


#####################
######## Install Drupal into local src directory
#####################

# if the drupal version is set we have a full version of drupal in the src directory
# credit = http://drupal.stackexchange.com/questions/23700/how-to-find-download-latest-drupal-version-via-bash
# get the latest version of drupal into a var
# if no version is set then get the latest
if [ -z "$drupal_version" ];then
echo "getting latest version of drupal from drupal.org"
latest_drupal_version=`wget -O- http://drupal.org/project/drupal | egrep -o 'drupal-[0-9\.]+.tar.gz' | sort -V  | tail -1`

#check if the version already exists on disk
if [ ! -f "$latest_drupal_version" ]; then
# Download the latest version
echo "downloading drupal version $latest_drupal_version"
wget  http://ftp.drupal.org/files/projects/$latest_drupal_version
fi

# ensure ./src/docroot exists
echo "making ./src/docroot"
mkdir -p ./src/docroot

# explode into the local src directory
echo "exploding $latest_drupal_version"
tar -xzf $latest_drupal_version -C ./src/docroot --strip-components=1
fi

# create useful directories 
echo "creating featues, custom and contrib directories in ./src/docroot/sites/all/modules"
mkdir -p src/docroot/sites/all/modules/{features,custom,contrib}

echo "creating libraries directory in ./src/docroot/sites/all/"
mkdir -p src/docroot/sites/all/libraries

###########################
####### copy a working settings file
###########################

# @TODO move the settings file to somewhere obvious
cp dockers/apache/drupal_docker_settings.php ./src/docroot/sites/default/settings.php

#########################
#### run site install on the apache-server container
########################

echo "running site install on the apache-server"
$vagrant_apache_docker_run  -- $drush_site_install
