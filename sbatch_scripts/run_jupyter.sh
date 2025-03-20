#!/bin/bash

# Time 
TIME="02:00:00"			# Set the time you need to run Jupyter Lab

ml purge

# Container
container=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Container/plastisphere_jupyter.sif

# You can launch jupyter notebook or lab: 
srun -A "C3SE2025-1-11" -n 1 -t ${TIME} apptainer  exec  $container jupyter lab --ip=0.0.0.0 --port 8888
