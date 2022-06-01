#!/bin/bash
. $home_var/geordiertools/useful_functions.sh
get_config_value "validator-name"
validatorname=$(echo $global_value)

get_config_value "platform-dir"
platformdir=$(echo $global_value)

log_file=$home_var/$platformdir/$platformdir.log



echo "Running purge of database"
cd "$home_var/$platformdir"

./target/release/stafi purge-chain --chain=mainnet
