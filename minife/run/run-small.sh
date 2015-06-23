#!/bin/sh
#PBS -q regular
#PBS -l mppwidth=144
#PBS -l walltime=00:10:00
#PBS -N miniFE.small
#PBS -V
cd $PBS_O_WORKDIR

# Small problem, sized for approximately 96 GB total memory usage.
# The script below is based on a 6 node, 144 MPI rank run on NERSC's Hopper
echo "running small problem on 6 nodes, 144 cores"
aprun -cc cpu -n 144 ./miniFE.x -nx 614 -ny 614 -nz 614

