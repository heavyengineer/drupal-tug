#!/bin/bash
# load the sql from a file because of the way docker escapes shell chars
source /vagrant/config/env_variables.config
filename=${sql_url##*/}

echo "loading sql file from $filename"
/root/.composer/vendor/bin/drush -y sql-cli --db-url=mysql://admin:changeme@mysql-server/drupal < /vagrant/db/${filename}
