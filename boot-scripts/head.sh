#!/bin/bash

if [ -f h2h.sh ] ; then
        echo 'Enabling head-to-head ssh connections under root'
        source h2h.sh
fi
if [ -f slurm_nodes.sh ] ; then
        echo 'Adding nodes from slurm.conf to /etc/hosts if necessary'
        source slurm_nodes.sh
fi
if [ -f mysql.sh ] ; then
        echo 'Updating mysql configuration: creating users, checking permissions, starting services, etc.'
        source mysql.sh
fi
if [ -f slurm-head.sh ] ; then
        echo 'Updating SLURM configuration: creating users, checking permissions, starting services, etc.'
        source slurm-head.sh
fi
if [ -f screenrc.sh ] ; then
        echo 'Updating /root/.screenrc to make sure that tabs are created for individual nodes'
        source screenrc.sh
fi
if [ -f pdsh.sh ] ; then
        echo 'Updating /etc/genders to enable all cluster hosts in pdsh and pdcp'
        source pdsh.sh
fi
if [ -f power.sh ] ; then
        echo 'Setting up tools required to obtain power measurements'
        source power.sh
fi
if [ -f hpc-tools.sh ] ; then
        echo 'Setting up tools such as gcc, OpenMPI, ATLAS, etc. and getting examples, primarily in /opt and /scratch'
        source hpc-tools.sh
fi
if [ -f mount-nfs-on-compute.sh ] ; then
        echo 'Try mounting nfs shares on compute nodes with pdsh'
        source mount-nfs-on-compute.sh
fi
