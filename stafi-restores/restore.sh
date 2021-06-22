#!/bin/bash
#Include functions file for re-use
. $HOME/geordiertools/useful_functions.sh

#Get Main Parameters############
get_config_value "platform-dir"
platformdir=$(echo $global_value)

get_config_value "platform-dir"
platformdir=$(echo $global_value)

log_file=$HOME/$platformdir/$platformdir.log
downloadsdir="$HOME/geordiertools/downloads"

#Read in environment variable from script switch
use_last_download=$1
#If calling this script as: ./restore.sh "nodownload" then it will use the last downloaded snapshot from variable: downloadsdir

if  [[ $use_last_download == "nodownload" ]] || [[ $use_last_download == "noextract" ]];
then
pre_downloaded_filename=$(ls $downloadsdir  -Art | head -n 1)
fi


## Functions

function getBytesFromFilename(){
  string="$1" #example: 2021-01-01-db-345678.gz" function returns 345678
  searchString="-db-"
  temp=${string#*$searchString} # this means everything after "and" will be inserted into temp
  searchString=".tar.gz"
  firstString=${temp=#*$searchString}
  emptyString=""
  bytesfromfilename="${firstString/$searchString/$emptyString}"
  echo $bytesfromfilename
}

cat << "MENUEOF"


##########
#        #
#  MENU  #
#        #
##########

MENUEOF

echo "Please choose the type of restore you require.  Read the options carefully."
give_1="Give me the most up to date latest snapshot"
give_2="Give me the second latest snapshot as I have issues with the first (DO NOT USE)"
#Choose what type of snapshot you require
PS3='Please enter the menu number below: '
options=("$give_1" "$give_2" "Quit")
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
            echo "You chose to get the second latest snapshot if there is one. Currently unavailable."
        chosen_file="secondlatest"
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


#Get the bytes from the filename portion after "-db-
dir_size=$(getBytesFromFilename "$latest_file")

echo "bytes from filename is $dir_size"

#Clear blocks folder
#rm -rf $downloadsdir/*.*
cd $downloadsdir

if [[ $pre_downloaded == "true" ]];
then

  latest_file=$pre_downloaded_filename
echo "Skipping download. Using last downloaded filename: $latest_file"
elif [ -z "$pre_downloaded" ] || [[ $pre_downloaded == "false" ]] || [[ $pre_downloaded == "" ]];
then
  #Download blocks.json compressed into a .gz
  echo "`date` - Downloading snapshot now from https://snapshots.geordier.co.uk/$latest_file"
  wget -Nc https://snapshots.geordier.co.uk/$latest_file -q --show-progress
  echo "`date` - Downloaded $downloadsdir/$latest_file"
fi


echo "Launching the start command at $HOME/geordiertools/stafi-startstop/start.sh to make sure directories are created for the restore"
#Start the node to create te directories etc...
$HOME/geordiertools/stafi-startstop/start.sh
echo "Sleeping for 10 seconds...This ensures directory creation as the node starts syncing in the background."
echo "During this short wait you should see your node appear on telemetry.polkadot.io on the stafi section"
echo "please wait...."
sleep 10
#Stop the node
echo "sleep ended"
$HOME/geordiertools/stafi-startstop/stop.sh
echo "`date` - Removing db files..."
sudo rm -rf "$HOME/.local/share/stafi/chains/stafi_mainnet/db/*"
echo "`date` - Starting extraction..."

#sudo mkdir $HOME/.local/share/stafi/chains/stafi_mainnet/db/
#sudo tar -xvf $downloadsdir/$latest_file --directory $HOME/.local/share/stafi/chains/stafi_mainnet/db

cd $HOME/.local/share/stafi/chains/stafi_mainnet/db/

if [[ $use_last_download == "noextract" ]];
then
echo "## NO EXTRACTION CHOSEN! ##"
else


sudo pigz -dc $downloadsdir/$latest_file | pv -s $dir_size | tar xf -

echo "`date` - Finished extracting"
fi

cd $HOME/$platformdir/

cat << "RESTOREMENUEOF"

##################
#                #
#  RESTORE MENU  #
#                #
##################

RESTOREMENUEOF

echo "Please choose the type of restore you require. The node will be stopped if it is currently launched in a background manner by using an & on the end.  Read the options carefully."

viewloglink="$HOME/geordiertools/stafi-startstop/viewlog.sh"

give_1="Start the node. I will run $viewloglink to monitor the background progress."
give_2="Start the node in the foreground so I can see it. Remember it should be started in the background later."
give_3="Do nothing, do not start the node I will take over from here."
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


if [[ $screentype == "background" ]];
then
$HOME/geordiertools/stafi-startstop/stop.sh
sleep 2
echo "Launching the start command at $HOME/geordiertools/stafi-startstop/start.sh"
$HOME/geordiertools/stafi-startstop/start.sh

echo "9999999" > $HOME/geordiertools/stafi-restores/sync.log

echo "Delegating to restorelogwatcher.sh please wait..."
sleep 1
$HOME/geordiertools/stafi-restores/restorelogwatcher.sh &
sleep 3


#Bit lazy but its late and 1=1 works right :D
while [[ "1" == "1" ]]
do
val=$(<$HOME/geordiertools/stafi-restores/sync.log)
echo "restore.sh sync val is $val"
if [[ $val -le 0 ]]; then
echo "0 Block Difference Detected"
        break;
fi
        sleep 2
done
echo "Complete from restore.sh!"



cat << "EOF"

########################
# CHAIN SYNC COMPLETED #
########################

EOF

echo "Launching the start command in the background at $HOME/geordiertools/stafi-startstop/start.sh"
$HOME/geordiertools/stafi-startstop/start.sh

elif [[ $screentype == "foreground" ]];
then

$HOME/geordiertools/stafi-startstop/stop.sh
sleep 1
$HOME/geordiertools/stafi-startstop/start.sh "foreground"

elif [[ $screentype == "extractonly" ]];
then

echo "You may want to run the following commands"
echo "$HOME/geordiertools/stafi-startstop/start.sh"
echo "You may also want to view the log after this by running $viewloglink"

fi
echo ""
echo ""
echo "## Script complete! ##"
