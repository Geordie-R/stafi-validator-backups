# Stafi Validator Backups and Restores (Under Construction)
Backups and Restores of stafi validators blocks.json

This project is the first iteration of a backups and restore solution for stafi, which will then be expanded to hopefully be for any substrate chain.  I'm no expert on substrate so this might start out a bit crazy! So be careful trying this on a live stafi chain!

```
cd ~
wget https://raw.githubusercontent.com/Geordie-R/stafi-validator-backups/main/installers/install-user.sh
wget https://raw.githubusercontent.com/Geordie-R/stafi-validator-backups/main/useful_functions.sh

chmod +x install-user.sh
chmod +x useful_functions.sh
sudo ./install-user.sh
```
Then you will be logged into the new user ready for the next script.

```
sudo $HOME/geordiertools/installers/install-geordiertools.sh
```
### Run Restore

```
sudo $HOME/geordiertools/stafi-restores/restore.sh
```
If you have already downloaded a download previously you can do the following instead

```
sudo $HOME/geordiertools/stafi-restores/restore.sh "nodownload"
```

