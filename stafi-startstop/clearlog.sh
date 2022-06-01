#!/bin/bash

home_var="/home/stafi"

. $home_var/geordiertools/useful_functions.sh
get_config_value "platform-dir"
platformdir=$(echo $global_value)
log_file=$home_var/$platformdir/$platformdir.log
#Empty the log file
> $log_file
