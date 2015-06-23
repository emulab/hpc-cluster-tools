#!/bin/bash

if [ -f slurm-compute.sh ] ; then
	echo 'Updating SLURM configuration: creating users, checking permissions, starting services, etc.'
	/bin/bash slurm-compute.sh
fi
if [ -f power.sh ] ; then
        echo 'Setting up tools required to obtain power measurements'
        source power.sh
fi
