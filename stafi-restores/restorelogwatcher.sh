#!/bin/bash

# This script provides a seperate log watch to calculate the sync progress
# of the node.  Every 2 seconds it writes the new difference between our
# head blocknumber and an external nodes head block number.

home_var="/home/stafi"

. $home_var/geordiertools/useful_functions.sh

function logToInteger(){
  intReturn=$(echo $1 | sed -r 's/\x1B\[(;?[0-9]{1,3})+[mGK]//g' | sed 's/#//')
  echo $intReturn
}

function isInt(){
  if [ "$1" -eq "$1" ] 2>/dev/null
  then
    echo "true"
  else
    echo "false"
  fi
}

get_config_value "platform-dir"
platformdir=$(echo $global_value)

downloadsdir="$HOME/geordiertools/downloads"

get_config_value "platform-dir"
platformdir=$(echo $global_value)
log_file=$home_var/$platformdir/$platformdir.log

externalAPI="https://rpc.stafi.io/"


their_head_hex=$(curl -H "Content-Type: application/json" -s -d '{"id":1, "jsonrpc":"2.0", "method": "chain_getHeader"}' $externalAPI | jq -r .result.number)
their_head_block_num=$(printf "%u\n" "$their_head_hex")


function writePercentage() {
##
##  \r = carriage return
##  \c = suppress linefeed
##

  diff=$(($2-$1))
  sumit=$(awk "BEGIN {print ($diff/$2)*100}")
  percentage=$(awk "BEGIN {print (100 - $sumit) }")
  #roundme=$(echo $percentage | awk '{print int($1+0.5)}')
  echo -en "\r$percentage% Chain Sync Completed\c\b"
}



synclog="$home_var/geordiertools/stafi-restores/sync.log"

echo "Please wait...you can review the sync progress also on https://telemetry.polkadot.io/#list/Stafi..."

while [[ 1 -eq 1 ]]
  do
    sleep 10
    their_head_hex=$(curl -H "Content-Type: application/json" -s -d '{"id":1, "jsonrpc":"2.0", "method": "chain_getHeader"}' $externalAPI | jq -r .result.number)
    their_head_block_num=$(printf "%u\n" "$their_head_hex")

    pre_our_head_block_num=$(tail -n 1 $home_var/stafi-node/stafi-node.log | awk '/Idle/ { print $10 }') #| sed 's/#//')
    our_head_block_num=$(logToInteger "$pre_our_head_block_num")

    oursBool=$(isInt $our_head_block_num)
    theirsBool=$(isInt $their_head_block_num)



    if [[ $theirsBool == "true" ]] && [[ $oursBool == "true" ]];
    then
#     echo "its an int for both!"
      blockdiff=$(($their_head_block_num-$our_head_block_num))
      echo $blockdiff > $synclog

   #   echo "Block difference is $blockdiff"

      if [[ $their_head_block_num -le $our_head_block_num ]];
      then
       # echo "Chain info is theirs: $their_head_block_num AND ours: $our_head_block_num breaking..."
        echo "Chain is sync!"
        break
      else
        #echo "their: $their_head_block_num is not less or equal to ours: $our_head_block_num"
        writePercentage $our_head_block_num $their_head_block_num
        #Dont need to loop too fast.  Sleep for a few secs

      fi
    else
#echo "hit else section"
     pre_our_head_block_num=$(tail -n 1 $home_var/stafi-node/stafi-node.log | awk '/Sync/ { print $13 }') #| sed 's/#//')
     our_head_block_num=$(logToInteger "$pre_our_head_block_num")
     oursBool=$(isInt $our_head_block_num)
     theirsBool=$(isInt $their_head_block_num)


     if [[ $theirsBool == "true" ]] && [[ $oursBool == "true" ]];
     then
       blockdiff=$(($their_head_block_num-$our_head_block_num))
       echo $blockdiff > $synclog
       writePercentage $our_head_block_num $their_head_block_num

     fi


    fi
  done

echo "####################restorelogwatcher is complete. Shutting down restorelogwatcher####################"
$home_var/geordiertools/stafi-startstop/stoplogwatcher.sh
