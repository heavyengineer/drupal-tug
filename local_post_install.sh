#!/bin/bash
# stuff that should be done after each db reload for instance and things that are unique to this installation
source ./env_variables.config
source ./drupal_variables.config


# set the fast var to skip the majority of drush commands to speed things up
# useful when developing drupal-tug
fast=1
if [ ! "$fast" ]; then

# add the memcache module if it's not already installed
$vagrant_apache_docker_run -- $drush_enable_memcache

# disable unneeded modules
disable_modules="comment color rdf toolbar shortcut overlay dashboard update"
$vagrant_apache_docker_run -- $drush dis $disable_modules

# modules we want to download only, not enable for example developer only modules
download_only="visualize_backtrace simplehtmldom-7.x-1.12 devel_themer"

# download and enable
download="entitycache views ctools entity features module_filter devel admin_menu apachesolr facetapi filter_perms"

$vagrant_apache_docker_run -- $drush dl $download $download_only

# this is because using en on it's own takes too long to check for stuff that we know
# we don't already have in most cases. so we download them all first and then enable
# them - because some of the modules we want to enable are submodules, 
# we do this in a seperate stanza
enable_sub_modules="views_ui admin_devel views_ui admin_menu_toolbar apachesolr_search"
$vagrant_apache_docker_run -- $drush en $download $enable_sub_modules 

# enable local modules
#$vagrant_apache_docker_run -- ${drush} en  

# feature revert
$vagrant_apache_docker_run -- $drush fra

# update the database
$vagrant_apache_docker_run -- $drush updb

# configure stage_file_proxy
if [ -n "$stage_file_proxy_origin" ]; then
$vagrant_apache_docker_run -- $drush en stage_file_proxy
$vagrant_apache_docker_run -- $drush variable-set stage_file_proxy_origin "$stage_file_proxy_origin"
fi

# image quality to 100%
$vagrant_apache_docker_run -- $drush variable-set image_jpeg_quality 100

# reset the admin password
echo "resetting $drupal_user_1_username password to $drupal_user_1_password"
$vagrant_apache_docker_run -- $drush_change_admin_passwd

# site name 
echo "setting site_name to $site_name"
$vagrant_apache_docker_run -- ${drush} variable-set site_name ${site_name}
fi

