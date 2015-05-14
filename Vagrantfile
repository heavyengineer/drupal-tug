VAGRANTFILE_API_VERSION = "2"  

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= 'docker'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

memcache=1
mysql=1
mysql-slave=0
apache=1
solr=0

if solr == 1
 config.vm.define "solr-server" do |v|
	v.vm.synced_folder ".", "/vagrant", disabled: true
   v.vm.provider "docker" do |d|
      d.name = "solr-server"
      d.image = "makuk66/docker-solr"
      d.ports = ["8983:8983"]
      d.remains_running = TRUE
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
      d.has_ssh = FALSE
      d.force_host_vm = true
  end
 end
end

if memcache == 1
 config.vm.define "memcache-server" do |v|
	v.vm.synced_folder ".", "/vagrant", disabled: true
   v.vm.provider "docker" do |d|
      d.name = "memcache-server"
      d.image = "memcached"
      d.ports = ["11211:11211"]
      d.remains_running = TRUE
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
      d.has_ssh = FALSE
      d.force_host_vm = true
  end
 end
end

if mysql == 1
  config.vm.define "mysql-server" do |v|
   v.vm.provider "docker" do |d|
      d.name = "mysql-server"
      d.image = "steevi6/mysql-server"
      d.ports = ["3306:3306"]
      d.remains_running = TRUE
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
      d.has_ssh = FALSE
      d.force_host_vm = true
  end
 end
end

#if mysql-slave == 1
#  config.vm.define "mysql-slave" do |v|
#   v.vm.provider "docker" do |d|
#      d.name = "mysql-slave"
#      d.image = "steevi6/mysql-server"
#      d.ports = ["3306:3306"]
#      d.remains_running = TRUE
#      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
#      d.has_ssh = FALSE
#      d.force_host_vm = true
#  end
# end
#end

if apache == 1

config.vm.define "apache-server" do |v|
    v.vm.provider "docker" do |d|
      	d.name = "apache-server"
      #	d.image = "steevi6/apache-php:latest"
      # build_dir is the source dockerfile that the image (above) is created from
       d.build_dir = "./dockers/apache"
      	d.has_ssh = FALSE
	# can't do port 80 without running as root.  could do iptables on the vhost tho
        d.ports = ["8080:80"]
	if mysql == 1
      		d.link("mysql-server:mysql-server")
	end
	if memcache == 1
      		d.link("memcache-server:memcache-server")
	end
	if solr == 1
      		d.link("solr-server:solr-server")
	end
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
      d.force_host_vm = true
    end
  end
end

end  
