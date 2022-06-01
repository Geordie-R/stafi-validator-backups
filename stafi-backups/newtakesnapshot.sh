#!/bin/bash

#if [[ $UID != 0 ]];
#then
#echo "Run as root or use sudo"
#fi

home_var= "/home/stafi"

. $home_var/geordiertools/useful_functions.sh

get_config_value "validator-name"
validatorname=$(echo $global_value)

get_config_value "platform-dir"
platformdir=$(echo $global_value)


sshfile="$home_var/.ssh/id_stafi"
sshportno=468
remote_user="youruser@yourwebspace.co.uk"
remote_server_folder="/var/www/yourwebspace.co.uk/public_html"
downloads_folder="$home_var/geordiertools/downloads"
datename=$(date +%Y-%m-%d_%H-%M)
filename="$downloads_folder/$datename-db-"
shcreate="$home_var/geordiertools/send-snapshot.sh"

#Remove older files just leave last couple
echo "Removing old backups"
ls -F $downloads_folder/*.gz | head -n -1 | xargs -r rm
#ls -F $downloads_folder/*.json | head -n -1 | xargs -r rm

dqt='"' # Store double quote for easy escaping

rm -rf $shcreate
echo "Exporting db directory on $datename..."

sudo $home_var/geordiertools/stafi-startstop/stop.sh
sleep 1

cd "$home_var/$platformdir/"
#./target/release/stafi export-blocks --pruning archive > $filename.json

dir_compress="$home_var/.local/share/stafi/chains/stafi_mainnet/db/"
dir_size=$(du -sb $dir_compress | awk '{print $1}')
filename="$downloads_folder/$datename-db-$dir_size"
if [[ $1 == "send" ]];
then
echo "" >> $shcreate
echo "Creating compressed archive..."
echo "cd $home_var/.local/share/stafi/chains/stafi_mainnet/db/" >> $shcreate
echo "tar -Scf - * | pv -s $dir_size | pigz -3 -p 4 > $filename.tar.gz" >> $shcreate

#echo "sudo pigz -Scf - $filename.tar.gz | pv -s $dir_size | tar cf -" >> $shcreate




# example extraction for above pv work     sudo pigz -dc $downloadsdir/$latest_file | pv -s $(($(du -sb $downloadsdir/$latest_file | awk '{print $1}') * 1)) | tar xf -


echo "ssh -p $sshportno -i '$sshfile' $remote_user 'find $remote_server_folder/ -name ${dqt}*.gz${dqt} -type f -size -1k -delete'" >> $shcreate
#echo "ssh -p $sshportno -i '$sshfile' $remote_user 'ls -F $remote_server_folder/*.gz | head -n -1 | xargs -r rm'" >> $shcreate
echo "ssh -p $sshportno -i '$sshfile' $remote_user 'ls -F $remote_server_folder/*.gz | xargs -r rm'" >> $shcreate #Remove all for now due to space issues
echo "rsync -rv -e 'ssh -p $sshportno' --progress $filename.tar.gz $remote_user:$remote_server_folder/" >> $shcreate

####################echo "rsync -rv -e 'ssh -p $sshportno' -i '$sshfile' --progress $filename.tar.gz $remote_user:$remote_server_folder/" >> $shcreate





chmod +x $shcreate
echo "Sending the backup...`date`"
$shcreate
cd "$home_var/$platformdir/"
echo "finished sending `date`"
sleep 1

fi

echo "Finished take-snapshot.sh at $datename"
echo "Starting Validator"

$home_var/geordiertools/stafi-startstop/start.sh
