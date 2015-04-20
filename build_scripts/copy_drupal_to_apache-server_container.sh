#!/bin/bash

# uses vagrant exec to copy the src directory to the apache-server container
$vagrant_apache_docker_run -- cp -r /vagrant/src/docroot /root/test
