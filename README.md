#DRUPAL-TUG

## Ultra quick-start
1. Clone the git repo `git clone git@github.com:heavyengineer/drupal-tug.git`
2. Change to the drupal-tug directory `cd drupal-tug`
3. Run `./build_env.sh`
4. Wait a few minutes
5. Connect to http://localhost:8080
6. Point your ide at drupal-tug/src
7. Start developing

##Overview

This project provides an automated LAMP development environment specifically for large Drupal sites but can be used for any level of development. 
It provides the following benefits:

1. The infrastructure can be stored in git (config/env_variables.config is all thats needed)
2. Developers joining your project have a greatly reduced rampup time - configure, or supply a configured, env_variables.config, run ./build_env.sh - get some coffee, come back in 20 mins, connect to localhost:8080 - start developing
3. Instead of migrating to a production infrastructure developers can develop the code on a near complete (if not complete) production environment significantly de-risking complex infrastructure deployments
4.  Never again will you hear 'well it works locally for me' *ymmv

## Pre-requisites
This has been tested on linux and MacOSX.
* Virtualbox (https://www.virtualbox.org/)
* For windows, install a version of Curl (http://curl.haxx.se/download.html)

##Quickstart - How to use
###Build a new site from scratch (no db, no existing repo)
####configure the env_variables.config file
1. If you want to install a fresh Drupal from scratch (i.e. run drush site-install) then set the sratch variable to 1 - this will run the script install_from_scratch.sh (see below)
2. If the scratch variable is set, indicate the version of Drupal you want to download by setting the drupal_version var - else it will default to the latest version
*** if on a windows platform, autodetection won't work so please ensure you set a version ***

###Build from an exsiting repo
####configure the config/env_variables.config file
1. Set client_name and site_name (this is a regular string used to populate the drupal site-name variable)
2. Set the repo_url - this is a standard git repo where your drupal site is installed.  It should follow acquia standards, so we're expecting the drupal site to be in docroot in the repo.  So once cloned it should be <repo>/docroot/index.php
3. Set default_branch - when the repo is downloaded it will automatically switch to this branch (e.g. develop) else will remain on master
4. Set sql_url - Unless you are building from hook_install() (not tested yet) then supply an sql file to start from. This should be in the ./db/ directory and should be named db.sql - so a known good setting for this var is db/db.sql 

*** Danger Will Robinson ***

If you download an sql file using something like phpmyadmin - you may find there is a line which creates a database and sets that db to be used during the install.  This will cause the build to fail (although all the containers will still run) as the app is looking for a db named drupal - not whatever phpmyadmin is setting it as.  So best to delete these lines and allow Drupal-tug to handle the db for you.  This problem doesnt exist if you use mysqldump to create the sql file. 
 

### In both cases then do this
1. run ./build_env.sh
2. connect to http://localhost:8080
3. point your ide at drupal-tug/src and develop as normal
4. profit

###Verify

Only your local machine, i.e. from your laptop, not from any virtual environments

1. Apache - go to localhost:8080 in a webbrowser
2. Mysql - connect to localhost:3306 admin/changeme - this means you can still use mysqlworkbench as normal from your dev machine
3. Memcache - connect to localhost:11211 (using nc or similar) and type 'stats' you should get a positive return
4. solr - connect to localhost:9000/solr (by default a solr server won't be configured.  See the vars in Vagrantfile.)

### Cannot forward port 8080,11211 or 3306 etc
* If the build fails and complains that it cannot forward a port (for instance cannot forward port 8080) - then this is likely because you already have an app running on that port on your local machine.  Either disable the app on your local machine or change the Vagrantfile and the ports (easier to disable the local app using the port).

##Details

What happens is this:
- Ubuntu 14 VM host machine is created in virtual box with docker installed 
- Then the vagrantfile downloads and installs the containers (apache, mysql, memcache and solr) from docker.io
- The apache webserver is looking at your local drupal-tug/src/docroot/ directory - it will work as if it's a local webserver

##DRUSH (Ddrush.sh)
There is a handy util in the root directory Ddrush.sh - this is a wrapper for drush commands. Append regular drush commands, e.g.  To clear the cache run:

./Drush.sh cc all

So any Drush commands can be appended to the ./Ddrush.sh script without having to create ssh connections etc. 

If you're at a command line in the proxy vhost and trying to run Drush using the 'docker exec' stuff, then you will need to use the full path for drush on the apache-server container e.g. /root/.composer/vendor/bin/drush
Drush requires ssh on the machines it's going to manage so the approach has been to instantiate a new container for every drush command.  Whilst this is resource intensive but the 'Docker' way and prevents an key mangement shenanigans.

##SSH to the proxy VM
Another util script is Tssh.sh - this gets the hex address of the proxy vm and dumps you at the vagrant command prompt.  From there you can run your favourite docker commands as normal. 
Instead of running ssh on each container, we can use vagrant docker-run to run commands on the instance after it's booted up.  
So for instance we should be able to run the mysql command to load the db assuming the sql file is available, or run drush site-install on the apache-webhead without requiring ssh.
However if you're going to ssh into the proxy, then docker exec onto the apache-server container only to run Drush, then consider using the Ddrush.sh script (described above) it's way easier at the terminal and in a script. 

##Drupal
The configuration follows standards.
- Further work is required for multisite - should work ok with domain access tho (untested)

###Stage File Proxy
This removes the need to have a local files directory (we have one tho to support uploads to the apache-server). When a file request is received it is proxied to the live/staging server and then copied locally. nuff said. The url is defined in the env_variables.config file

###Thalt.ssh
`Thalt.ssh` will connect to the proxy vm and halt the vm, suspending the containers.  So when i want to down a machine i do `./Thalt.ssh` then switch to another drupal-tug and do `./build_env.sh`

Sometimes, on my linux box, i get an error when i re-run `build_env.sh` - i need to nuke the apache-server and rebuild it, something to do with the vboxfs stuff.  I just do `vagrant destroy -f apache-server`, then redo the `build_env.sh` - takes about another 10seconds but rebuilds the FS layers from disk.

###backupdb.sh
`backupdb.sh` will start a new mysql-server container, and create a backup in drupal-tug/db - this is date time stamped

###reload_db.sh
`reload_db.sh` will start a new mysql-server containers, drop the db and load the file in drupal-tug/db/db.sql
The aspiration is for db.sql to be a softlink to the various backups but sometimes this causes a weird loop with the drush commands used to rebuild the db so best to rename the backup to db.sql

### how to rebuild?
Run ./build_env.sh - this will reuse the containers downloaded and created (so it is faster) but will rerun all the drupal commands so you effectively have a fresh build. 

Useful commands
-----------------
Run these from the drupal-tug directory on your local machine

`vagrant status`

returns the status of all the containers that are part of this VM

`vagrant global-status`

lists the status of all the VMs and containers running on this host

`vagrant docker-logs <id>`

returns the log output of a specific container where id is the first four chars of the id

`vagrant docker-run <id> -- cmd`

runs 'cmd' on a fresh container of the same type as the specified container id

e.g. 

`vagrant docker-run apache-server -- drush -r /vagrant/src/docroot upwd superuser --password=superuser`

`vagrant docker-run apache-server -- drush -r /vagrant/src/docroot cc all`

## SSH to the proxy vm
run `./Tssh.sh` to connect to the proxy VM that hosts your containers, then run these commands

### find the id of the container you want to connect to
docker ps -a

### spawn a bash shell
docker exec -it <id> /bin/bash

### SSH into a container
If you're trying to do this then you're probably doing something wrong... talk to steev@initsix.co.uk

##Changing container and vm configuration
One thing that wasn't clear from the existing docs was that `vagrant ssh hexaddress` etc can be used to target individual containers and vms.  But is also REQUIRED to target the proxy vm.  so executing `vagrant halt;vagrant destroy -f' in the vagrant directory, doesnt affect the proxy vm.  you need to do `vagrant halt hexaddess;vagrant destroy -f hexaddress` etc

additionally, vagrant reload doesnt work as you'd expect it.  it requires a complete deletion to get new networking and folder configs into the vm.  so if you change a port or a folder you need to completely nuke the set and being again. 

###Networking isolation
If you're inspecting a codebase/app that may have been compromised, then the safest way to do this is through disabling the routing in the ubuntu host.  

sudo vi /etc/sysctl.conf 
sudo sysctl -p /etc/sysctl.conf

you can then attach to a bash prompt on a container, try and ping yahoo.com and you shouldnt be able to.  You may need to build some kind of proxy tho as the packets can be received at the remote machine, but can't find their way back to the host. perhaps another option is to disable the default gateway for the host machine?

###Updating images
If you need to add software to a docker image, like if you need to install drush etc.  Then vagrant ssh to the vhost machine, then connect using docker exec -it /bin/bash and install the software normally (or use the headless install versions preferably) and then commit the image and push it to docker.  Then to use the new image in the docker environment change the tag in the Vagrantfile for the image and it will grab the new version and run the command that way. 

###redundant images
If you find you have broken images listed in the output of vagrant global-status (e.g. containers that are gone but their status is hanging around) then edit the index here ~/.vagrant.d/data/machine-index/index

###GIT
when the script runs it will switch to the branch noted in ./env_variables.config ONLY if checking out code from a repo as well.  If the repo already exists nothing will be changed, so it's possible to rerun the build, without touching the code so you can change branches at will, rerun the build and have a new db on your custom branch. 

###PHP
Php configuration by .htaccess - change the file in src/docroot/.htaccess - permanent changes can be made to the php.ini file but this is out of scope in this release 

###Xdebug
This should just work.  So in netbeans i configure the host as localhost:8080
Xdebug is setup to accept your ip address as supplied by the browser and route the traffic back to it. 

#TODO
1. Varnish server
2. Solr server configuration
3. mysql webadmin interface
4. automatically detect and delete a line in a supplied db.sql that creates a db
5. automate disabling routing for inspecting a compromised code base
6. behat editor interface
7. phpunit
9. Squid server for locally storing container images
10. https setup(?)
12. Create gui for using the system
13. nodejs for unified log output
14. Gruntjs for running unit tests on branch commit
18. use iptables on the virtual host machine to provide port redirection from 8080 to 80 so we don't need the port extension locally
19. setup slave sql server
20. setup drupal reroute_mail project
