#!/bin/bash

# Script written by Dmitry Duplyakin to create tabs in screen for individual hosts in the cluster 
# (this script will update /root/.screenrc)

LOG=/var/log/init-screenrc.log
CONF=/root/.screenrc
DONE_MARK="#!!!COMPLETED!!!"

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >> $LOG
   exit 1
fi

# Check if the file has been completed already
cat $CONF | grep $DONE_MARK
# Investigate the returned code
if [ $? -eq 0 ]; then
  echo "$CONF is already completed and does not need to be updated" >> $LOG
  exit 0
fi

# Highest tab ID present in /root/screenrc (i.e. the last one present in the file)
# Remove empty lines, remove comments, take the last line, get the number in the 4th column
LAST_NUM=`cat $CONF | grep -e '^$' -v | grep -v "^#" | tail -1 | sed "s/\t/\ /g" | sed "s/ \+/ /g" | cut -f4 -d\ `

echo "Highest tab ID found in $CONF is: $LAST_NUM" >> $LOG
# Check that the ID is indeed a number
if [ "$LAST_NUM" -eq "$LAST_NUM" ] 2>/dev/null; then
  echo "Highest tab ID is indeed a number" >> $LOG
else
  echo "Highest tab ID is not a number. Change the last line (before the comments) in $CONF" >> $LOG
  exit 1
fi
NUM=$((LAST_NUM+1))

# ALL hosts in the profile (according to metadata from geni-get)
HOSTS=`geni-get manifest | xmlstarlet sel -t -v "/_:rspec/_:node[@client_id]/@client_id"`

echo "List of hosts in the profile (from the mainfest)" >> $LOG
echo $HOSTS >> $LOG

echo "Updating $CONF by adding tabs for hosts from the experiment's manifest" >> $LOG
for h in `echo $HOSTS`
do
  # Check if $h is already present in #CONF
  cat $CONF | grep -v "^#"  | grep $h
  if [ $? -eq 0 ]; then
    echo "$h is already in $CONF. Do nothing" >> $LOG
  else
    # Format of the line that will be added for h in CONF: screen -t <host> <ID> ssh <host>
    echo -n "Adding a line for $h into $CONF" >>$LOG
    echo "screen   -t $h   $NUM   ssh $h" >> $CONF
    # Increment the counter
    NUM=$((NUM+1))
    echo " - DONE" >> $LOG
  fi
 
done

# Finalizing the update
echo " " >> $CONF
echo "select 0" >> $CONF
echo $DONE_MARK >> $CONF
echo "$CONF has been updated" >> $LOG 
