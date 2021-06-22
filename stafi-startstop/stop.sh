#!/bin/bash
#. $HOME/geordiertools/useful_functions.sh
#get_config_value "platform-dir"
#platformdir=$(echo $global_value)
#echo "$platformdir is the platform dir"

#screen -S "$platformdir" -X at "#" stuff $'\003'
#sleep 1
#echo "Validator stop script finished"



# gracefully stop node
collect_pid=$(pgrep stafi)

if [ ! -z "$collect_pid" ]; then
    if ps -p $collect_pid > /dev/null; then
        kill -SIGINT $collect_pid
    fi
    while ps -p $collect_pid > /dev/null; do
        sleep 1
    done
fi
echo "node stopped"
