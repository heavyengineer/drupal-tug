#!/bin/bash

# if docroot doesnt exist, clone it in
if [ ! -d ${repo_dir}docroot ]; then
	echo "cloning remote git repo"
	git clone $repo_url $repo_dir
	echo "Running git clone $repo_url $repo_dir"
	cd $repo_dir
	git fetch
	echo "checking out $default_branch"
	git checkout $default_branch
	cd ..
else
	echo "repo already downloaded"
fi
