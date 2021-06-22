#!/bin/bash


#Add user to sudo group
 read -p "What ubuntu user would you like to create for running your node? I suggest stafi.  It is ok if it already exists:" user
echo "The user needs to be part of the sudo group.  Adding it now if it hasnt already been added"


if id "$user" >/dev/null 2>&1; then
        echo "user already exists"
else
        echo "user does not exist...creating"
        adduser --gecos "" $user
        adduser $user sudo

fi

#sudo usermod -aG sudo $user
echo "finished installing"

cd /home/$user/
apt-get -y update
apt-get -y upgrade
apt-get -y install git

git clone https://github.com/Geordie-R/stafi-validator-backups.git geordiertools
chown -R $user: /home/$user/geordiertools/
find * -type f -iname "*.sh" -exec chmod +x {} \;
rm README.md
