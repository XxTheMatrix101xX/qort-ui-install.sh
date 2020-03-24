#!/bin/bash

# first iteration Qortal UI install script
# Qortal Blockchain Project - 2020

# if you want to see your debug messages, uncomment this variable
DEBUG_IS_ON=yes

# you can use this function for debug messages
# usage: command: "debug File Is Open" --(gives oputput)--> "At 11:44:00 File Is Open"
function debug()
{
  if [ "${DEBUG_IS_ON}" = "yes" ]
  then
    NOW=$(date +"%T")
    echo "At $NOW Debug: ${*}" >&2
  fi
}


function print_help()
{
  echo -e "Syntax: $0 [-i] [-b] [-p] >&2"
  echo -e "\t[-i]: install every repository needed, install dependencies, clone git repos, do yarn linking and building, and build and run final UI"
  echo -e "\t[-b]: update all git repos, stash, pull, yarn relink and install, and rebuild"
  echo -e "\t[-p]: not implemented yet"
  exit 1
}

# install every repository needed, install dependencies, clone git repos, do yarn linking and building, and build and run final UI
function process_full_install()
{
  echo -e '---DOING APT UPDATE FIRST---'
  
  sudo apt-get update -qq > /dev/null
  
  echo -e '--SETTING UP YARN AND NODE APT SOURCES AND INSTALLING DEPENDENCIES FOR NODE ATTEMPT ONE---'
  
  sudo apt-get -y install curl dirmngr apt-transport-https lsb-release ca-certificates -qq > /dev/null
  #curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo -e "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list  
  curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
# sudo apt update 
#  echo -e 'installing node.js 12 sources'
#  sudo echo "deb https://deb.nodesource.com/node_12.x eoan main" | sudo tee /etc/apt/sources.list.d/nodesource.list
#  sudo echo 'deb-src https://deb.nodesource.com/node_12.x eoan main' >> /etc/apt/sources.list.d/nodesource.list
  
  echo -e '---INSTALLING NODEJS 12+ SOURCES WITH TWO POSSIBLE OPTIONS IN CASE OF FAILURE OF ONE---'
  
  sudo echo "deb https://deb.nodesource.com/node_12.x eoan main" | sudo tee /etc/apt/sources.list.d/nodesource.list
  sudo echo 'deb-src https://deb.nodesource.com/node_12.x eoan main' >> /etc/apt/sources.list.d/nodesource.list
  sudo apt-get update -qq > /dev/null
#  sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  
  echo -e '---INSTALLING DEPENDENCIES!---'
  
  sudo apt-get update  -qq > /dev/null
  
  echo -e '---INSTALLING NODE.JS---'
  
  sudo apt -y install nodejs -qq > /dev/null
  
  echo -e '---INSTALLING YARN---'
  
  sudo apt -y install yarn -qq > /dev/null
  
  echo -e '---INSTALLING NPM AND ZIP/UNZIP---'
  
  sudo apt-get -y install npm -qq > /dev/null
  sudo apt-get -y install zip -qq > /dev/null
  sudo apt-get -y install unzip -qq > /dev/null
  
  echo -e '---INSTALLING GIT---'
  
  sudo apt-get -y install git -qq > /dev/null
  
  echo -e '---CLONING ALL UI REPOSITORIES---'
  
  sudo git clone https://github.com/QORT/qortal-ui && sudo git clone https://github.com/QORT/qortal-ui-plugins && sudo git clone https://github.com/QORT/qortal-ui-core && sudo git clone https://github.com/QORT/qortal-ui-crypto
  
  echo -e '---EXECUTING ALL PRE-BUILD TASKS---'
  
  cd qortal-ui-core 
  sudo yarn install 
  sudo yarn unlink 
  sudo yarn link 
  cd ../qortal-ui-plugins
  sudo yarn install 
  sudo yarn unlink 
  sudo yarn link
#  echo -e 'FIXING main.js COMMENT ISSUE'
#  cd plugins/core
#  sudo sed -i '21s/.*/    fetch(url).then(res => console.log(res))/' main.src.js
#  echo -e 'FIXED FOREVER'
#  cd ../../../frag-qortal-crypto
  cd ../qortal-ui-crypto
  sudo yarn install 
  sudo yarn unlink 
  sudo yarn link
  cd ../qortal-ui 
  sudo yarn link @frag-crypto/qortal-ui-core 
  sudo yarn link @frag-crypto/qortal-ui-plugins 
  sudo yarn link @frag-crypto/qortal-ui-crypto
  
  echo -e '---BUILDING UI SERVER THEN RUNNING IN THIS TERMINAL WINDOW - KEEP WINDOW OPEN!---'
  
  sudo yarn run build 
  
  echo -e '---RUNNING UI SERVER - ACCESS VIA - http://localhost:12388 - KEEP THIS WINDOW OPEN AS LONG AS YOU ARE PLANNING TO USE UI---' 
  
  sudo yarn run server

# you can use debug function
   debug Procesing 'full install'
}

# backup and update all git repos, yarn relink and install, and rebuild
function process_update_all_github_and_rebuild()
{
  echo THIS DOES NOT WORK
  sleep 99999
  echo -e '---MAKING BACKUP OF EXISTING FOLDERS JUST IN CASE---'
  
  sudo mkdir BACKUPS
  sudo mv frag-* BACKUPS 
  sudo mv qortal-ui BACKUPS
  sudo zip -r BACKUP-latest.zip BACKUPS
  sudo rm -R BACKUPS
  
  echo -e  '---CLONING NEW CODE FROM GITHUB REPOS---'
  
  sudo git clone https://github.com/QORT/qortal-ui && sudo git clone https://github.com/QORT/frag-default-plugins && sudo git clone https://github.com/QORT/frag-core && sudo git clone https://github.com/QORT/frag-qortal-crypto
  
  echo -e '---DOING ALL PRE-BUILD TASKS---'
  
  cd frag-core
  sudo yarn install 
  sudo yarn unlink
  sudo yarn link
  cd ../frag-default-plugins
  sudo yarn install
  sudo yarn unlink
  sudo yarn link
#  echo -e 'fixing min.src.js file'
#  cd plugins/core
#  sudo sed -i '21s/.*/    fetch(url).then(res => console.log(res))/' main.src.js
#  echo -e 'fixed forever'
#  cd ../../../frag-qortal-crypto
  cd ../frag-qortal-crypto
  sudo yarn install
  sudo yarn unlink
  sudo yarn link
  cd ../qortal-ui
  sudo yarn link @frag-crypto/frag-core
  sudo yarn link @frag-crypto/frag-default-plugins
  sudo yarn link @frag-crypto/frag-qortal-crypto
  
  echo -e '---REBUILDING UI NOW---'
  
  sudo yarn run build
 
  echo -e '---RUNNING UI - LEAVE THIS WINDOW OPEN TO KEEP UI RUNNING---'
  
  sudo yarn run server 
  
  # you can use debug function
   debug Procesing 'update all github and rebuild'
}

# check for github updates with a pull
function process_check_for_github_updates()
{
  # to do: write code here
  # you can use debug function
   debug Procesing 'check for github updates'
}

while getopts ":ibp" o
	
do
  case "$o" in
  i) process_full_install ;;
  b) process_update_all_github_and_rebuild ;;
  p) process_check_for_github_updates ;;
  *) 
  esac
done;
