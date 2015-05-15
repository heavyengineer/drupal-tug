#!/bin/bash
# docker drush helper script
# enables the user to run drush commands by supplying arguments to a container run
source ./config/vagrant_commands.config

# this should accept and execute all the space seperated commands from the arguments
# as one bug drush command.  So running ./Ddrush.sh cc all should run 'drush cc all' 
# an apache container
$vagrant_apache_docker_run -- $drush $*
