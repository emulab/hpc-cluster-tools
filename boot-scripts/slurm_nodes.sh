#!/bin/bash

# Script written by Dmitry Duplyakin to add compute nodes from SLURM config to /etc/hosts
# Necessary for starting slurmctld (all nodes need to have resolvable names)

LOG=/var/log/init-slurm_nodes.log
SLURM_CONF=/etc/slurm-llnl/slurm.conf
NODE_PREFIX=node
IP_PREFIX=10.99.99.

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 
   exit 1
fi

# Looking for a line with the format: NodeName=node[X-Y] State=UNKNOWN
SLURM_RANGE=`cat $SLURM_CONF | grep NodeName | sed 's/.*\[//' | sed 's/\].*//'`
SLURM_LB=`echo $SLURM_RANGE | cut -f1 -d-`
SLURM_UB=`echo $SLURM_RANGE | cut -f2 -d-`

for nn in `seq $SLURM_LB $SLURM_UB`
do
  cat /etc/hosts | grep "$NODE_PREFIX$nn" > /dev/null 2>&1

  # Investigate the returned code
  if [ $? -eq 0 ]; then
    echo "$NODE_PREFIX$nn is present in /etc/hosts." >> $LOG
  else
    echo "$NODE_PREFIX$nn is not found in /etc/hosts. Adding: $IP_PREFIX$nn $NODE_PREFIX$nn" >> $LOG
    echo "$IP_PREFIX$nn   $NODE_PREFIX$nn" >> /etc/hosts
  fi
done

echo "Done!" >> $LOG
