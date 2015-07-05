#!/bin/bash

# the db file needs to be made available to the vagrant and docker instances
# because nfs can't traverse links.
# check the file hasn't already been copied (md5sum?)
# copy it to the db/ directory if it hasnt
# previously we were using a static filename, db.sql.  this is no longer needed as we can reference the
# name from the .config file. might be some use to version these files tho?
if [ $DEBUG -eq 1 ];then
me="copy_db.sh"
echo ">>>>>>>>executing $me"
fi

. config/env_variables.config

if [ ! -d "db" ];then
	echo "db directory missing, recreating"
  mkdir db
fi

# check if the file has already been copied
filename=${sql_url}

if [ ! -f "db/${filename}" ];then
echo "copying ${filename}"
  cp ${sql_url} ./db
  else
	  echo "${filename} already exists"
fi
