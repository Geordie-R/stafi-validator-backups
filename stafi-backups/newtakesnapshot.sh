
#!/bin/bash

#if [[ $UID != 0 ]];
#then
#echo "Run as root or use sudo"
#fi


. $HOME/geordiertools/useful_functions.sh

get_config_value "validator-name"
validatorname=$(echo $global_value)

get_config_value "platform-dir"
platformdir=$(echo $global_value)


sshfile="$HOME/.ssh/id_rsa"
sshportno=22
remote_user="your-ubuntu-user@your-server-host.com"
remote_server_folder="/var/www/remotewebsite.co.uk/public_html/"
downloads_folder="$HOME/geordiertools/downloads"
datename=$(date +%Y-%m-%d_%H-%M)
filename="$downloads_folder/$datename-blocks"
shcreate="$HOME/geordiertools/send-snapshot.sh"

#Remove older files just leave last couple
echo "Removing old backups"
ls -F $downloads_folder/*.gz | head -n -1 | xargs -r rm
ls -F $downloads_folder/*.json | head -n -1 | xargs -r rm

dqt='"' # Store double quote for easy escaping

#rm -rf $shcreate
echo "Exporting blocks.json on $datename..."

$HOME/geordiertools/stafi-startstop/stop.sh
sleep 1

cd "$HOME/$platformdir/"
#./target/release/stafi export-blocks --pruning archive > $filename.json





#echo "HELLO WORLDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD123D" >> $filename.json


if [[ $1 == "send" ]];
then
echo "Creating send-snapshot.sh..."
echo "tar -Scvzf $filename.tar.gz ~/.local/share/stafi/chains/stafi_mainnet/db" >> $shcreate
echo "ssh -p $sshportno -i '$sshfile' $remote_user 'find $remote_server_folder -name ${dqt}*.gz${dqt} -type f -size -1k -delete'" >> $shcreate
echo "ssh -p $sshportno -i '$sshfile' $remote_user 'ls -F $remote_server_folder*.gz | head -n -1 | xargs -r rm'" >> $shcreate
echo "rsync -rv -e 'ssh -p $sshportno' -i ${dqt}$sshfile${dqt} --progress $filename.tar.gz $remote_user:$remote_server_folder" >> $shcreate


chmod +x $shcreate
echo "Sending the backup...`date`"
$shcreate
echo "finished sending `date`"
sleep 1
#rm $shcreate
fi

echo "Finished take-snapshot.sh at $datename"
echo "Starting Validator"

$HOME/geordiertools/stafi-startstop/start.sh
