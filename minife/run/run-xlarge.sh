#!/bin/sh
#PBS -q regular
#PBS -l mppwidth=?
#PBS -l walltime=?
#PBS -N miniFE.xlarge
#PBS -V
cd $PBS_O_WORKDIR
 
# Extra large problem, sized for approximately 960 TB total memory usage.
# This problem is ~10,000 times larger than the small problem.
echo "running large problem on ? nodes, ? cores"
mpirun -n ? ./miniFE.x -nx 13236 -ny 13236 -nz 13236

