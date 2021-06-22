# Stafi Validator Backups and Restores (Under Construction)
Backups and Restores of stafi validators blocks.json

This project is the first iteration of a backups and restore solution for stafi, which will then be expanded to hopefully be for any substrate chain.  I'm no expert on substrate so this might start out a bit crazy! So be careful trying this on a live stafi chain!

```
cd ~
wget https://raw.githubusercontent.com/Geordie-R/stafi-validator-backups/main/installers/install-user.sh
chmod +x install-user.sh
sudo ./install-user.sh
```

Then later once the user is created do the following.  LEts say we called the user 'stafi' the command next would contain stafi.

```
su - stafi
sudo ./$HOME/geordiertools/installers/install-geordiertools.sh


```
