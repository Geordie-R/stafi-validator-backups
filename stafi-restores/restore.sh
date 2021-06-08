#!/bin/bash

#https://snapshots.geordier.co.uk/latestdownload.php
. $HOME/geordiertools/useful_functions.sh
get_config_value "platform-dir"
platformdir=$(echo $global_value)

downloadsdir="$HOME/geordiertools/downloads"

get_config_value "platform-dir"
platformdir=$(echo $global_value)
log_file=$HOME/$platformdir/$platformdir.log


cat << "MENUEOF"
███╗   ███╗███████╗███╗   ██╗██╗   ██╗
████╗ ████║██╔════╝████╗  ██║██║   ██║
██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
MENUEOF

echo "Please choose the type of restore you require.  Read the options carefully."

give_1="Give me the most up to date latest snapshot"
give_2="Give me the second latest snapshot as I have issues with the first"
give_3="Give me the third latest snapshot, this my last hope."
#Choose what type of snapshot you require, which in turn goes to my website to retrieve the files that line up together.
PS3='Please enter the menu number below: '
options=("$give_1" "$give_2" "$give_3" "Quit")
chosen_file=""
select opt in "${options[@]}"
do
    case $opt in
        "$give_1")
        chosen_file="latest"
            echo "You chose to get the latest snapshot"
        break
            ;;
        "$give_2")
            echo "You chose to get the second latest snapshot"
        chosen_file="secondlatest"
break
            ;;
        "$give_3")
            echo "You chose to get the third latest snapshot"
        chosen_file="thirdlatest"
break
            ;;
        "Quit")
echo "You chose to quit"
            exit 1
break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

mkdir -p $downloadsdir
latestsnapshot=$(curl -s https://snapshots.geordier.co.uk/latestdownload.php)
read -a arr <<< $latestsnapshot

if [[ $chosen_file == "latest" ]];
then
latest_file=${arr[0]};
elif [[ $chosen_file == "secondlatest" ]];
then
latest_file=${arr[1]};
elif [[ $chosen_file == "thirdlatest" ]];
then
latest_file=${arr[2]};
fi

#Clear blocks folder
#rm -rf $downloadsdir/*.*
cd $downloadsdir

#Download blocks.json compressed into a .gz
echo "Downloading compressed blocks json now from https://snapshots.geordier.co.uk/$latest_file"
#  wget -Nc https://snapshots.geordier.co.uk/$latest_file -q --show-progress  -O - | sudo tar -xvz --strip=4



echo "Downloaded compressed blocks json $latest_file"


jsonfile=$(ls *.json | head -1)
echo "json file downloaded is $jsonfile"

cd $HOME/$platformdir/

cat << "RESTOREMENUEOF"

██████╗ ███████╗███████╗████████╗ ██████╗ ██████╗ ███████╗    ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝    ████╗ ████║██╔════╝████╗  ██║██║   ██║
██████╔╝█████╗  ███████╗   ██║   ██║   ██║██████╔╝█████╗      ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
██╔══██╗██╔══╝  ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝      ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
██║  ██║███████╗███████║   ██║   ╚██████╔╝██║  ██║███████╗    ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
RESTOREMENUEOF

echo "Please choose the type of restore you require. The node will be stopped if it is currently launched in a background manner by using an & on the end.  Read the options carefully."


give_1="Import the blocks in the background. I can use the viewlog file to monitor progress."
give_2="Import the blocks into the foreground but later then run the node in the background. Remember cancelling with Ctrl C at any point would stop the node"
give_3="Extract the blocks json file into downloads folder and allow me to read it in myself however I want. Code will be provided."
#Choose what type of snapshot you require, which in turn goes to my website to retrieve the files that line up together.
PS3='Please enter the menu number below: '
options=("$give_1" "$give_2" "$give_3" "Quit")
snaptypephp=""
select opt in "${options[@]}"
do
    case $opt in
        "$give_1")
        screentype="background"
            echo "You chose background screen restore"
        break
            ;;
        "$give_2")
            echo "You chose to create a screen and restore into and watch progress"
        screentype="foreground"
break
            ;;

         "$give_3")
            echo "You chose to just extract it only"
        screentype="extractonly"
break
            ;;

        "Quit")
echo "You chose to quit"
            exit 1
break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done










viewloglink="$HOME/geordiertools/stafi-startstop/viewlog.sh"







if [[ $screentype == "background" ]];
then
$HOME/geordiertools/stafi-startstop/stop.sh


echo "starting to import blocks, you may launch the $viewloglink file to view progress as we go"
./target/release/stafi import-blocks --pruning archive $downloadsdir/$jsonfile >> $log_file 2>&1 &
#sleep 3
#$HOME/geordiertools/stafi-restore/restorelogwatcher.sh
echo "Launching the start command at $HOME/geordiertools/stafi-startstop/start.sh"
#$HOME/geordiertools/stafi-startstop/start.sh
elif [[ $screentype == "foreground" ]];
then
#$HOME/geordiertools/stafi-startstop/stop.sh
./target/release/stafi import-blocks --pruning archive $downloadsdir/$jsonfile
echo "*Launching the start command at $HOME/geordiertools/stafi-startstop/start.sh"
$HOME/geordiertools/stafi-startstop/start.sh

elif [[ $screentype == "backgroundscreen" ]];
then
#UNUSED - Left in for options in future
sudo screen -dmS "stafi-node" ./target/release/stafi import-blocks --pruning archive $downloadsdir/$jsonfile
elif [[ $screentype == "foregroundscreen" ]];
then
echo ""
#UNUSED - Left in for options in future
#sudo screen -mS "stafi-node" ./target/release/stafi import-blocks --pruning archive $downloadsdir/$jsonfile
elif [[ $screentype == "noscreen" ]];
then
echo ""
#UNUSED - Left in for options in future
#sudo ./target/release/stafi import-blocks --pruning archive $downloadsdir/$jsonfile
elif [[ $screentype == "extractonly" ]];
then
echo "json file downloaded is $jsonfile"
echo "You may want to run the following command whenever you wish to restore to the foreground"
echo "./target/release/stafi import-blocks --pruning archive $downloadsdir/$jsonfile"
echo "alternatively....to restore to the background"
echo "./target/release/stafi import-blocks --pruning archive $downloadsdir/$jsonfile >> $log_file 2>&1 &"
echo "then....to start the node you can run"
echo "$HOME/geordiertools/stafi-startstop/start.sh"
echo "...and if you have launched to the background go and view the log file here: $viewloglink"


fi