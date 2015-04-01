#!/bin/bash
# docker drush helper script
# enables the user to run drush commands by supplying arguments to a container run
source ./drupal_variables.config

# this should accept and execute all the space seperated commands from the arguments
# as one bug drush command.  So running ./Ddrush.sh cc all should run 'drush cc all' 
# an apache container
date=`date +%s`
$vagrant_apache_docker_run -- $drush sql-dump --result-file=/vagrant/db/bak.${date}.sql
