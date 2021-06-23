#!/bin/bash
. ../useful_functions.sh

#Add user to sudo group
 read -p "What ubuntu user would you like to create for running your node? I suggest stafi.  It is ok if it already exists:" user
echo "The user needs to be part of the sudo group.  Adding it now if it hasnt already been added"


if id "$user" >/dev/null 2>&1; then
        echo "user already exists"
else
        echo "user does not exist...creating"
        adduser --gecos "" $user
        adduser $user sudo

fi

#sudo usermod -aG sudo $user
echo "finished installing"

cd /home/$user/
apt-get -y update
apt-get -y upgrade
apt-get -y install git

git clone https://github.com/Geordie-R/stafi-validator-backups.git geordiertools
mkdir -p  /home/$user/geordiertools/downloads/
chown -R $user: /home/$user/geordiertools/
find * -type f -iname "*.sh" -exec chmod +x {} \;
rm README.md





#INSTALLER

dir_tools="$HOME/geordiertools"
dir_restore="$dir_tools/stafi-restores"
dir_backups="$dir_tools/stafi-backups"
dir_startstop="$dir_tools/stafi-startstop"
dir_downloads="$dir_tools/downloads"
config_file="$dir_tools/config.ini"



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

chown -R $user: $config_file

echo "finished install"
