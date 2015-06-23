#!/bin/bash 

# Try mounting nfs shares on compute nodes with pdsh
c=0
lim=6
interval=5
until [ $c -ge $lim ]
do
  echo "Attempt: $c/$lim"
  pdsh -g compute "mount /opt ; mount /scratch ; mount /users" 
  c=$[$c+1]
  sleep $interval
done
