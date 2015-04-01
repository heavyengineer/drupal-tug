#!/bin/bash
# load the sql from a file because of the way docker escapes shell chars

#/usr/bin/drush -y sql-cli --db-url=mysql://admin:changeme@mysql-server/drupal < /vagrant/db/db.sql
/root/.composer/vendor/bin/drush -y sql-cli --db-url=mysql://admin:changeme@mysql-server/drupal < /vagrant/db/db.sql
