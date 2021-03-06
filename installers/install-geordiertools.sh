#!/bin/bash
dir_tools="$HOME/geordiertools"
. $dir_tools/useful_functions.sh
#INSTALLER

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

echo "

███████╗██╗███╗   ██╗██╗███████╗██╗  ██╗███████╗██████╗
██╔════╝██║████╗  ██║██║██╔════╝██║  ██║██╔════╝██╔══██╗
█████╗  ██║██╔██╗ ██║██║███████╗███████║█████╗  ██║  ██║
██╔══╝  ██║██║╚██╗██║██║╚════██║██╔══██║██╔══╝  ██║  ██║
██║     ██║██║ ╚████║██║███████║██║  ██║███████╗██████╔╝
╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═════╝

██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
"                                                      
echo " "
echo "## Next Steps ##"
echo "Now you need to build a stafi node if you haven't built one already from https://docs.stafi.io/stafi-chain/network/participants/validator-sv/run-a-node "
echo "Once you have built a stafi node or if you have previously built one you can then continue to run the next script restore.sh as per instructions from https://stafidocs.geordier.co.uk/restores/restore-stafi-node"
