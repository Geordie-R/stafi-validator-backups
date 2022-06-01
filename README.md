# Stafi Validator Backups and Restores Beta (Geordiertools)
Backups and Restores of stafi validators blocks db.

This project is the first iteration of a node backups and restore solution for stafi, which will then be expanded to hopefully be for any substrate chain.  I'm no expert on substrate so this might start out a bit crazy! So be careful trying this on a live stafi chain!

I have done a video a few months back. See the link below for instructions and video. 

# ONLY use the user stafi when it asks, its been quickly hardcoded in for this specific branch!!

https://stafidocs.geordier.co.uk/

Leave me feedback in stafi discord or on telegram at https://t.me/GeordieR

# Special Notice

When following https://stafidocs.geordier.co.uk/ come back to this read me to get alternative URLS.  First portion of code in the manual is this

```cd ~
wget https://raw.githubusercontent.com/Geordie-R/stafi-validator-backups/HardCodedPathIssueAlternative/installers/install-user.sh
wget https://raw.githubusercontent.com/Geordie-R/stafi-validator-backups/HardCodedPathIssueAlternative/useful_functions.sh

chmod +x install-user.sh
chmod +x useful_functions.sh

sudo ./install-user.sh
```

Then this...

```
sudo /home/stafi/geordiertools/installers/install-geordiertools.sh
```

Then the restore.sh is this

```
/home/stafi/geordiertools/stafi-restores/restore.sh
```

IF you get an error similar to  "Cannot find macro vec" when installing the stafi node run the following. Thanks to SR on discord cheers.
```
rustup install 1.59.0
rustup default 1.59.0
```
