#!/bin/bash
home_var="/home/stafi"
. $home_var/geordiertools/useful_functions.sh
get_config_value "validator-name"
validatorname=$(echo $global_value)
get_config_value "platform-dir"
platformdir=$(echo $global_value)
if [[ $validatorname == "" ]];
then
  read -p "What is your validator name?: " validatorname
fi

log_file=$home_var/$platformdir/$platformdir.log
tail -f $log_file
