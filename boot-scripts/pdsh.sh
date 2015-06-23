#!/bin/bash

# Script written by Dmitry Duplyakin to enable all hosts in the cluster in pdsh
# (this script will update /etc/genders)

LOG=/var/log/init-pdsh.log
CONF=/etc/genders
DONE_MARK="#!!!COMPLETED!!!"

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >> $LOG
   exit 1
fi

# Check if the file has been updated already
cat $CONF | grep $DONE_MARK
# Investigate the returned code
if [ $? -eq 0 ]; then
  echo "$CONF is already completed and does not need to be updated" >> $LOG
  exit 0
fi

DEFGR=`cat $CONF | grep "DEFAULTGROUP" | sed "s/\ //g" | cut -f2 -d=`

echo "Default group name in $CONF is: $DEFGR" >> $LOG

# ALL hosts in the profile (according to metadata from geni-get)
HOSTS=`geni-get manifest | xmlstarlet sel -t -v "/_:rspec/_:node[@client_id]/@client_id"`

echo "List of hosts in the profile (from the mainfest)" >> $LOG
echo $HOSTS >> $LOG

echo "Updating $CONF by adding all hosts in group $DEFGR" >> $LOG
for h in `echo $HOSTS`
do
  # Check if $h is already present in #CONF
  cat $CONF | grep -v "^#"  | grep $h
  if [ $? -eq 0 ]; then
    echo "$h is already in $CONF. Do nothing" >> $LOG
  else
    # Format of the line that will be added for h in CONF: <hostname> <groupname>
    echo -n "Adding a line for $h into $CONF" >>$LOG
    echo "$h  $DEFGR" >> $CONF
    # Increment the counter
    echo " - DONE" >> $LOG
  fi
 
done

# Finalizing the update
echo " " >> $CONF
echo $DONE_MARK >> $CONF
echo "$CONF has been updated" >> $LOG 
