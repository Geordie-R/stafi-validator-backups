#!/bin/bash

. ../useful_functions.sh

#INSTALLER

dir_tools="$HOME/geordiertools"
dir_restore="$dir_tools/stafi-restores"
dir_backups="$dir_tools/stafi-backups"
dir_startstop="$dir_tools/stafi-startstop"
dir_downloads="$dir_tools/downloads"
config_file="$dir_tools/config.ini"
echo "Creating $dir_restore"
mkdir -p "$dir_restore"
echo "Creating $dir_backups"
mkdir -p "$dir_backups"
echo "Creating $dir_startstop"
mkdir -p "$dir_startstop"
echo "Creating $dir_downloads"
mkdir -p "$dir_downloads"
echo "Installing PV"
apt-get install pv #Provides progress
echo "Installing Pigz"
apt-get install pigz #gzip with threads

echo "Installing JQ"
apt-get install jq #install jq to interpret 

#If we havent got a config file with our validator name in  lets create one.  We need this for starting the chain.
get_config_value "validator-name"
validatorname="$(echo $global_value)"

if [[ $validatorname == "" ]];
then
 read -p "What is your validator name to display on telemetry.polkadot.io (stafi)?: " validatorname

echo validator-name=$validatorname >> $config_file
fi

platformname="stafi-node"

get_config_value "platform-dir"
platformdir="$(echo $global_value)"


if [[ $platformdir == "" ]];
then
 read -p "What is the main platform directory name?  E.g. stafi is stafi-node: " platformdir

echo platform-dir=$platformdir >> $config_file
fi

#Add user to sudo group
 read -p "What ubuntu user do you use for running your node? I suggest stafi:" user
echo "The user needs to be part of the sudo group.  Adding it now if it hasnt already been added"
sudo usermod -aG sudo $user
echo "finished installing"
