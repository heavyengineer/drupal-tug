#!/bin/bash
#
# move the existing settings.php to settings.php.bak
if [ -f src/docroot/sites/default/settings.php ];then
mv src/docroot/sites/default/settings.php src/docroot/sites/default/settings.php.bak
fi

# copy the versions in from the docker build directories (these need to be moved somewhere more obvious)
cp dockers/apache/drupal_docker_default.settings.php src/docroot/sites/default/settings.php
cp dockers/apache/drupal_docker_settings.php src/docroot/sites/default/

# link the default file to settings.php
#cd src/docroot/sites/default
#ln -s drupal_docker_default.settings.php settings.php


