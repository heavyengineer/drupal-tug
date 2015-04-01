#!/bin/bash
# build drupal software from source and load db

# load vars from the config file to prevent errant changes in here
source ./env_variables.config
source ./drupal_variables.config

######## site building starts here #########

echo "building site for ${client_name}"

if [ -z ${scratch} ];then

# if docroot doesnt exist, clone it in
if [ ! -d ${repo_dir}/docroot ]; then
	echo "cloning remote git repo"
	git clone $repo_url $repo_dir
	echo "Running git clone ${repo_url} $repo_dir"
	cd $repo_dir
	git fetch
	echo "checking out ${default_branch}"
	git checkout ${default_branch}
	cd ..
else
	echo "repo already downloaded"
fi

# if the $db_url is null
if [ -z ${db_url} ]; then
# in this instance the user wants to load the db from scratch (and prob configure
# the site using .install updates() and using code in a repo rather than a base install
# install the site from scratch
$vagrant_apache_docker_run  -- $drush_site_install
else
# load the db
echo "loading db"

# load the db using drush for better error reporting and reliability etc
$vagrant_apache_docker_run  -- $drush_create_db
$vagrant_apache_docker_run  -- $drush_restore_db
fi

else

#######################
#######     Install from scratch
#######################
source ./install_from_scratch.sh
source ./local_post_install.sh
fi
