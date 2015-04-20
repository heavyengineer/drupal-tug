#!/bin/bash

# sync the src directory to the container and set the correct permissions etc
# takes anything passed as an argument

vagrant docker-run apache-server -- $*
