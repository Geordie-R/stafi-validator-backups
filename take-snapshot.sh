#!/bin/bash


sshportno=468
remote_user="stafiuser@snapshots.geordier.co.uk"
remote_server_folder="/var/www/snapshots.geordier.co.uk/public_html/"
current_folder=$(pwd)
datename=$(date +%Y-%m-%d_%H-%M)
filename="$current_folder/blocks/$datename-blocks"
shcreate="newexportblocks.sh"
ssh_file="$HOME/.ssh/id_stafi"


dqt='"' # Store double quote for easy escaping

rm -rf $shcreate
echo "Exporting blocks.json on $datename..."

./target/release/stafi export-blocks --pruning archive > $filename.json

echo "tar -Scvzf $filename.tar.gz $filename.json" >> $shcreate
echo "ssh -p $sshportno -i '$ssh_file' $remote_user 'find $remote_server_folder -name ${dqt}*.gz${dqt} -type f -size -1k -delete'" >> $shcreate
echo "ssh -p $sshportno -i '$ssh_file' $remote_user 'ls -F $remote_server_folder*.gz | head -n -1 | xargs -r rm'" >> $shcreate
echo "rsync -rv -e 'ssh -p $sshportno' -i ${dqt}$ssh_file${dqt} --progress $filename.tar.gz $remote_user:$remote_server_folder" >> $shcreate

chmod +x $shcreate
echo "Running the backup..."
./$shcreate
echo "finish on $datename"
