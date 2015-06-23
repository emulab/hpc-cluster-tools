#!/bin/sh
#PBS -q regular
#PBS -l mppwidth=49152
#PBS -l walltime=00:10:00
#PBS -N miniFE.large
#PBS -V
cd $PBS_O_WORKDIR

# Large problem, sized for approximately 32 TB total memory usage.
# The script below is based on a 2048 node, 49152 MPI rank run on NERSC's Hopper
echo "running large problem on 2048 nodes, 49152 cores"
aprun -cc cpu -n 49152 ./miniFE.x -nx 4293 -ny 4293 -nz 4293

