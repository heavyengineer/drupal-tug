#TUG
This project provides an automated LAMP development environment specifically for large Drupal sites. 

##Quickstart - How to use
1. configure the env_variables.config file
4. run ./build_env.sh
5. connect to http://localhost:8080
8. profit

###Verify
1. Apache - go to localhost:8080 in a webbrowser
2. Mysql - connect to localhost:3306 admin/changeme
3. Memcache - connect to localhost:11211 (using nc or similar) and type 'stats' you should get a positive return
3. solr - connect to localhost:9000/solr

##Details
What happens is this:
- Ubuntu 14 VM host machine is created in virtual box with docker installed in it
- Then the vagrantfile downloads and installs the containers from docker.io
- The apache webserver is looking at ./src/docroot as the docroot, i.e. the src directory in the same directory as the VagrantFile

##DRUSH
Use the full path for drush on the apache-server container e.g. /root/.composer/vendor/bin/drush
Drush requires ssh on the machines it's going to manage.  I think this is only required on the webhead.  There is a link in the TODO section that describes how to proxy ssh connections using drush options so it should be possible to create two sets of drupal aliases one for the physical host machine that proxies a connection to the vagrant vm which then connects to the docker over ssh.  The other set connect to the webhead from the vagrant proxy so the user doesnt need to set anything up, just 'vagrant ssh' the 'drush cc all' etc.
Once drush is setup it can then handle the sql connection to install the db if required.

## instead of ssh
we can use vagrant docker-run to run commands on the instance after it's booted up. 
So for instance we should be able to run the mysql command to load the db assuming the sql file is available, or run drush site-install on the apache-webhead without requiring ssh

##Drupal
- Only the sites/default and sites/all directories are supported. further work is required for multisite - should work ok with domain access
- Always downloads the latest version of drupal into the docker build.  this may not be the best behaviour

###Stage File Proxy
This removes the need to have a local files directory (we have one tho to support uploads). When a file request is received it is proxied to the live/staging server and then copied locally. nuff said. The url is defined in the env_variables.config file


useful commands**
-----------------
vagrant status 				returns the status of all the containers that are part of this VM
vagrant global-status   	lists the status of all the VMs and containers running on this host
vagrant docker-logs <id> 	returns the log output of a specific container where id is the first four chars of the id
vagrant docker-run <id> -- cmd  runs 'cmd' on a fresh container of type
vagrant docker-run apache-server -- drush -r /vagrant/src/docroot upwd superuser --password=superuser
vagrant docker-run apache-server -- drush -r /vagrant/src/docroot cc all
----------------- 

# SSH to the proxy vm (that houses the containers in the docker instance)

# get the id of the default host
vagrant global-status

# connect to the host where id is the first 4 chars of the id string
vagrant ssh <id> 

# find the id of the container you want to connect to
docker ps -a

# spawn a bash shell
docker exec -it <id> /bin/bash

# connect to the shell
docker attach <id>

# SSH into a container
If you're trying to do this then you're probably doing something wrong... talk to steev@initsix.co.uk

Changing container and vm configuration
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
