#!/bin/bash
# backup the current database and place into the db directory with a timestamp set
source ./config/vagrant_commands.config

date=`date +%s`
$vagrant_apache_docker_run -- $drush sql-dump --result-file=/vagrant/db/bak.${date}.sql
