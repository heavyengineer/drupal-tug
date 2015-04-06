#!/bin/bash

#######################
#######     Install from scratch
#######################
echo "installing site from scratch"

# copy src dir if exists
if [ -d ./src ]; then
cp -r src src.`date +"%T"`bak
fi

# nuke the src directory
rm -rf ./src
mkdir ./src

# Download and explode drupal
drupal_archive=drupal-${drupal_version}

# if it's not already downloaded
if [ ! -d ${drupal_archive}.tar.gz ]; then
curl --silent --output ./${drupal_archive}.tar.gz  http://ftp.drupal.org/files/projects/${drupal_archive}.tar.gz
fi

# if not already decompressed - decompress
if [ ! -d ${drupal_archive} ]; then
# explode into src and rename docroot
tar -xzf ./${drupal_archive}.tar.gz
fi

# create local drupal 
mv ${drupal_archive} src/docroot

# create useful directories 
mkdir src/docroot/sites/all/modules/{features,custom,contrib}
mkdir src/docroot/sites/all/libraries

# install the site from scratch
$vagrant_apache_docker_run  -- $drush_site_install
