#!/bin/bash

# Script written by Dmitry Duplyakin that fixes possible problems with mysql after profile redeployment
# Creates users and groups, as well restarts the service

G=1787
U=1787

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 
   exit 1
fi

groupadd -g $G mysql
adduser -u $U -gid $G mysql --system
chown -R mysql:mysql /usr/share/mysql
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/log/mysql
service mysql restart
