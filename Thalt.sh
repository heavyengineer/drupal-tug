#!/bin/bash

# ssh to the current default

#bget default id
id=`vagrant global-status | grep default | grep running | awk '{print $1}'`

vagrant halt $id
