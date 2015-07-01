#!/bin/bash
me="download_drupal.sh"
echo ">>>>>>>>executing $me"

# if a version of drupal has been specified in the env_variables.conf
if [ -n "$drupal_version" ];then

echo "drupal_version var has been declared as $drupal_version so we will attempt to download it"

# Download and explode drupal if it's not already downloaded
if [ ! -f ${drupal_archive}.tar.gz ]; then
	echo "no existing version of $drupal_version found, so we will attempt to download a new copy"
	curl --silent --output ./$drupal_archive.tar.gz  http://ftp.drupal.org/files/projects/$drupal_archive.tar.gz
fi

# if not already decompressed - decompress
if [ ! -d $drupal_archive ]; then
	echo "decompressing $drupal_archive"
	# explode into src and rename docroot
	#@TODO use the -C switch to remove the need for the mv below
	tar -xzf ./$drupal_archive.tar.gz 
fi

# create local drupal 
echo "moving $drupal_archive to src/docroot"
mv $drupal_archive src/docroot

fi

# if the drupal version is set we have a full version of drupal in the src directory
# credit = http://drupal.stackexchange.com/questions/23700/how-to-find-download-latest-drupal-version-via-bash
# get the latest version of drupal into a var
# if no version is set then get the latest
if [ -z "$drupal_version" ];then

echo "getting latest version of drupal from drupal.org"

# wget isnt available on stock macosx
#latest_drupal_version=`wget -O- http://drupal.org/project/drupal | egrep -o 'drupal-[0-9\.]+.tar.gz' | sort -V  | tail -1`
latest_drupal_version=`curl -Lvs http://drupal.org/project/drupal 2>&1 |  egrep -o 'drupal-[0-9\.]+.tar.gz' | sort  | tail -1`
echo $latest_drupal_version

#check if the version already exists on disk
if [ ! -f "$latest_drupal_version" ]; then

# Download the latest version
echo "downloading drupal version $latest_drupal_version"

# wget isn't available by default on a mac
#wget  http://ftp.drupal.org/files/projects/$latest_drupal_version
curl --silent --output ./$latest_drupal_version  http://ftp.drupal.org/files/projects/$latest_drupal_version
# check the format of this file
echo "checking file format $latest_drupal_version"
file $latest_drupal_version
fi

# ensure ./src/docroot exists
echo "making ./src/docroot"
mkdir -p ./src/docroot

# explode into the local src directory
echo "exploding $latest_drupal_version"
tar -xzf $latest_drupal_version -C ./src/docroot --strip-components=1
fi

# create useful directories 
echo "creating featues, custom and contrib directories in ./src/docroot/sites/all/modules"
mkdir -p src/docroot/sites/all/modules/{features,custom,contrib}

echo "creating libraries directory in ./src/docroot/sites/all/"
mkdir -p src/docroot/sites/all/libraries
