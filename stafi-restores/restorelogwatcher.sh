#!/bin/bash

# This script provides a seperate log watch to calculate the sync progress
# of the node.  Every 2 seconds it writes the new difference between our
# head blocknumber and an external nodes head block number.



. $HOME/geordiertools/useful_functions.sh

function logToInteger(){
  intReturn=$(echo $1 | sed -r 's/\x1B\[(;?[0-9]{1,3})+[mGK]//g' | sed 's/#//')
  echo $intReturn
}


get_config_value "platform-dir"
platformdir=$(echo $global_value)

downloadsdir="$HOME/geordiertools/downloads"

get_config_value "platform-dir"
platformdir=$(echo $global_value)
log_file=$HOME/$platformdir/$platformdir.log

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



synclog="$HOME/$platformdir/sync.log"
touch $synclog
#Set a stupid low figure to start
echo -999999999999 > $synclog



while [[ 1 -eq 1 ]]
  do
    their_head_hex=$(curl -H "Content-Type: application/json" -s -d '{"id":1, "jsonrpc":"2.0", "method": "chain_getHeader"}' $externalAPI | jq -r .result.number)
    their_head_block_num=$(printf "%u\n" "$their_head_hex")

    pre_our_head_block_num=$(tail -n 1 $HOME/stafi-node/stafi-node.log | awk '/Idle/ { print $10 }') #| sed 's/#//')
    our_head_block_num=$(logToInteger $pre_our_head_block_num)
#    echo "BLOCKDIFF PRE"
    blockdiff=$(($their_head_block_num-$our_head_block_num))
    echo $blockdiff > $synclog

    if [[ $their_head_block_num -le $our_head_block_num ]];
    then
      echo "breaking..."
      break
      echo "Chain is sync!"
    else
   #   echo "their: $their_head_block_num ours: $our_head_block_num"
      writePercentage $our_head_block_num $their_head_block_num
      #Dont need to loop too fast.  Sleep for a few secs
      sleep 2

    fi
    sleep 1
  done

echo "complete"

#./stop.sh
#"$HOME/geordiertools/stafi-startstop/stop.sh"
