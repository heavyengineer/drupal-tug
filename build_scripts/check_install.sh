#!/bin/bash

# vars for coloured output
RED='\033[0;31m'
NC='\033[0m'

# checks for vagrant
command -v vagrant >/dev/null 2>&1 || { 
printf "${RED}ERROR:${NC} Vagrant version > 1.6 is required but it's not installed. Aborting.\nInstall from here https://www.vagrantup.com/downloads.html\n\n"; 
exit 1; 
}

# checks vagrant version
[[ $("vagrant" --version) =~ ([0-9][.][0-9.]*) ]] && version="${BASH_REMATCH[1]}"
if ! awk -v ver="$version" 'BEGIN { if (ver < 1.6) exit 1; }'; then
  printf "${RED}ERROR:${NC} Vagrant version 1.6 or higher required. Aborting.\nInstall from here https://www.vagrantup.com/downloads.html\n\n.";
exit 1;
fi

# check for virtual box
command -v vboxmanage >/dev/null 2>&1 || { 
printf "${RED}ERROR:${NC} Virtual box is required but it's not installed.  Aborting.\nInstall from here https://www.virtualbox.org/wiki/Downloads.\n\n"; 
exit 1; }

# check virtualbox is working correctly else the user may miss the error as it scrolls past
e=`vboxmanage --version | awk '{print $1}'`
if [[ $e == 'WARNING:' ]];then
printf "${RED}ERROR:${NC} Virtual box isn't working correctly. Aborting.\nCheck the output below.\n\n"; 
vboxmanage --version
exit 1; 
fi
