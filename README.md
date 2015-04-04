#TUG
This project provides an automated LAMP development environment specifically for large Drupal sites. 
It provides the following benefits:

1. The infrastructure can be stored in git (env_variables.conf is all thats needed)
2. Developers joining your project have a greatly reduced rampup time - configure, or supply a configured, env_variables.config, run ./build_env.sh - get some coffee, come back in 20 mins, connect to localhost:8080 - start developing
3. Instead of migrating to a production infrastructure developers can develop the code on a near complete (if not complete) development environment significantly de-risking complex infrastructure deployments
4.  Never again will you hear 'well it works locally for me'

##Quickstart - How to use
###Build from an exsiting repo
####configure the env_variables.config file
1. set the repo_url - this is a standard git repo where your drupal site is installed.  It should follow Acquia standards, so we're expecting the drupal site to be in docroot in the repo.  So once cloned it should be <repo>/docroot/index.php
 set client_name and site_name (this is a regular string used to populate the drupal site-name variable)
2. set the repo_url - this is a standard git repo where your drupal site is installed.  It should follow acquia standards, so we're expecting the drupal site to be in docroot in the repo.  So once cloned it should be <repo>/docroot/index.php
3. set default_branch - when the repo is downloaded it will automatically switch to this branch (e.g. develop) else will remain on master
4. set sql_url - Unless you are building from hook_install() (not tested yet) then supply an sql file to start from. This should be in the ./db/ directory and should be named db.sql - so a known good setting for this var is db/db.sql 
*** Danger Will Robinson ***
If you download an sql file using something like phpmyadmin - you may find there is a line which creates a database and sets that db to be used during the install.  This will cause the build to fail (although all the containers will still run) as the app is looking for a db named drupal - not whatever phpmyadmin is setting it as.  So best to delete these lines and allow Drupal-tug to handle the db for you.  This problem doesnt exist is you use mysqldump to create the sql file. 
 
###Build a new site from scratch (no db, no existing repo)
####configure the env_variables.config file
1. If you want to install a fresh Drupal from scratch (i.e. run drush site-install) then set the sratch variable to 1 - this will run the script install_from_scratch.sh (see below)
2. If the scratch variable is set, indicate the version of Drupal you want to download by setting the drupal_version var - else it will (should) default to the latest version)

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
4. solr - connect to localhost:9000/solr (by default a solr server won't be configured.  See the vars in Vagrantfile.

##Details

What happens is this:
- Ubuntu 14 VM host machine is created in virtual box with docker installed in it
- Then the vagrantfile downloads and installs the containers from docker.io (except apache-server which is currently built from source)
- The apache webserver is looking at it's own internal version of Drupal as the docroot, i.e. the src directory in your local directory is not used except for sites/all - which is linked from the webserver

##DRUSH (Ddrush.sh)
There is a handy util in the root directory Ddrush.sh - this is a wrapper for drush commands. Append regular drush commands, e.g.  To clear the cache run:

./Drush.sh cc all

So any Drush commands can be appended to the ./Ddrush.sh script without having to create ssh connections etc. 

If you're at a command line in the proxy vhost and trying to run Drush using the 'docker exec' stuff, then you will need to use the full path for drush on the apache-server container e.g. /root/.composer/vendor/bin/drush
Drush requires ssh on the machines it's going to manage so the approach has been to instantiate a new container for every drush command.  this is resource intensive but the 'Docker' way.

##SSH to the proxy VM
Another util script is Tssh.sh - this gets the hex address of the proxy vm and dumps you at the vagrant command prompt.  From there you can run your favourite docker commands as normal. 
Instead of running ssh on each container, we can use vagrant docker-run to run commands on the instance after it's booted up.  
So for instance we should be able to run the mysql command to load the db assuming the sql file is available, or run drush site-install on the apache-webhead without requiring ssh.
However if you're going to ssh into the proxy, then docker exec onto the apache-server container only to run Drush, then consider using the Ddrush.sh script (described above) it's way easier at the terminal and in a script. 

##Drupal
The configuration follows standards but may not be what you're expecting.  

The directory ./src - should contain all your normal Drupal working files.  However to facilitate the webserver being able to write to the sites/default/files directory - and still run as www-data - we have had to create a dummy copy of the latest drupal core on the webserver during build (this is why the entire apache-server instance is built from scratch right now). 

So when the container is built it downloads the latest drupal to /var/www/site inside the docker container.  We then soft link the sites/all directory to the shared filesystem /vagrant/src/docroot/sites/all - so if you 'hack core' in drupal-tug/src/docroot/index.php - nothing will happen as this isnt the index.php that is being used.  We are using /var/www/site/docroot/index.php  on the apache-server - this is read only on the webserver so if your app won't work and you've hacked core?  Go home developer, you're drunk. 

- Only the sites/all directories are supported for editing in your IDE. 
- Further work is required for multisite - should work ok with domain access tho (untested)
- Always downloads the latest version of drupal into the docker build.  this may not be the best behaviour

###Stage File Proxy
This removes the need to have a local files directory (we have one tho to support uploads to the apache-server). When a file request is received it is proxied to the live/staging server and then copied locally. nuff said. The url is defined in the env_variables.config file


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
Php configuration by .htaccess is hard to do as the .htaccess is mounted internally in the container, the .htaccess in your docroot on your local machine will have no effect. Php Directives are set in the Dockerfile when the container is built. 

###Xdebug
To get this to work we need to map the ports from the local vagrant machine to the laptop somehow.  So when the debugger client sends a request, the webserver opens a connection to either a known ip or the ip specified in the request header from the debugger client. We prob have little control here so to prevent the user having to do some configuration i think we should specify some good defaults to work in 80% of situations. 
If you need to debug or make sure traffic is happening, do this on the vagrant proxy machine sudo tcpdump -i eth0  -s 1500 port 9000
So traffic is getting from the remote machine to the virtual host but then isnt getting routed to the IDE on the physical machine.  Ideally we need to automate this but for now add an ip address in the env config or something and write a manual rule to o map the ports to the physical machine


#TODO
1. Varnish server
2. Solr server configuration
3. mysql webadmin interface
4. sites/all/translations needs to be writable by the webserver or download all translations at once
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
