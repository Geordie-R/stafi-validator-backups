#!/bin/bash


#Add user to sudo group
 read -p "What ubuntu user would you like to create for running your node? I suggest stafi:" user
echo "The user needs to be part of the sudo group.  Adding it now if it hasnt already been added"


if id "$user" >/dev/null 2>&1; then
        echo "user already exists"
else
        echo "user does not exist...creating"
        adduser --gecos "" --disabled-password $username
        adduser $username sudo

fi

#sudo usermod -aG sudo $user
echo "finished installing"
