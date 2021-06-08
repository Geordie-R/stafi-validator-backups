#!/bin/bash
. $HOME/geordiertools/useful_functions.sh
get_config_value "validator-name"
validatorname=$(echo $global_value)

get_config_value "platform-dir"
platformdir=$(echo $global_value)

log_file=$HOME/$platformdir/$platformdir.log



echo "Running purge of database"
cd "$HOME/$platformdir"

./target/release/stafi purge-chain --chain=mainnet
