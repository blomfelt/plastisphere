#!/usr/bin/env bash

#SBATCH -A C3SE2025-1-11 -p vera
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH -J moveFiles
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=/cephyr/NOBACKUP/groups/jbp/felix/logs/moveFiles.%J.err
#SBATCH --output=/cephyr/NOBACKUP/groups/jbp/felix/logs/moveFiles.%J.out

###
#
# Date: 2025.03.05
# Author: Felix Blomfelt
#
# Description: 
# 
# Usage: 
# sbatch moveFiles.sh
#
###


### Set parameters
# Input directory
INDIR=/cephyr/NOBACKUP/groups/jbp/felix;

# Output directory
OUTDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters;

# Temp files directory variable
WORKING_TMP=$TMPDIR/MOVE_TMP;

### Purge modules
module purge

# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;

rsync -ahz --progress $INDIR $OUTDIR 

