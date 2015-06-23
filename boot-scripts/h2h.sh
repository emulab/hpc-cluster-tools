#!/bin/bash

# Script written by Dmitry Duplyakin to enable head-to-head ssh connections
# Necessary for querying all nodes using pdsh, e.g. `pdsh -a uptime`

LOG=/var/log/init-h2h.log
KEY=/root/.ssh/id_rsa
AUTH_KEYS=/root/.ssh/authorized_keys2 
HOST=head

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 
   exit 1
fi

# Try and see if it works already (-oBatchMode=yes fails the command instead of prompting for password)
ssh -oBatchMode=yes $HOST hostname > /dev/null 2>&1

# Investigate the result
if [ $? -eq 0 ]; then
    echo "OK. $HOST can ssh into $HOST." >> $LOG
else
    echo "FAIL. $HOST can't ssh into $HOST." >> $LOG
    echo "Attempting to fix." >> $LOG

    if [ -f $KEY ] && [ -f "$KEY.pub" ];
    then
        echo "Private key pair $KEY[.pub] exists" >> $LOG
    else
        echo "Private key pair $KEY[.pub] does not exist (or one of the parts is missing)" >> $LOG
	echo "Generating a new key pair" >> $LOG
	ssh-keygen -f $KEY -t rsa -b 2048 -N ''
    fi
    echo "Adding the key to $AUTH_KEYS" >> $LOG
    cat "$KEY.pub" >> $AUTH_KEYS
    echo "Done!" >> $LOG
fi
