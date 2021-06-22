#!/bin/bash
. $HOME/geordiertools/useful_functions.sh
get_config_value "platform-dir"
platformdir=$(echo $global_value)
log_file=$HOME/$platformdir/$platformdir.log
#Empty the log file
> $log_file
