#!/bin/bash

back_or_foreground=$1

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

echo "Running start.sh for validator '$validatorname'"
cd "$home_var/$platformdir"
#screen -dmS "$platformdir" ./target/release/stafi --validator --name="$validatorname" --execution=NativeElseWasm

if [ -z "$back_or_foreground" ] || [[ $back_or_foreground == "background" ]];
then
#Run in the background

./target/release/stafi --validator --name="$validatorname" --execution=NativeElseWasm >> $log_file 2>&1 &
elif [[ $back_or_foreground == "foreground" ]];
then
#Run in the foreground
echo "Warning: Running in the foreground"
./target/release/stafi --validator --name="$validatorname" --execution=NativeElseWasm
fi
