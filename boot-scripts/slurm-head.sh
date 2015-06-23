#!/bin/bash

# Script written by Dmitry Duplyakin that fixes possible problems with slurm after profile redeployment
# Creates necessary users and groups, updates permissions, as well as restarts services

MG=1789
MU=1789
SG=1790
SU=1790

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 
   exit 1
fi

groupadd -g $MG munge
adduser -u $MU -gid $MG munge --system

groupadd -g $SG slurm 
adduser -u $SU -gid $SG slurm --system --shell /bin/bash

chown -R munge:munge /var/run/munge
chown -R munge:munge /var/log/munge
chown -R munge:munge /etc/munge

service munge restart
service slurm-llnl restart
service slurm-llnl-slurmdbd restart
