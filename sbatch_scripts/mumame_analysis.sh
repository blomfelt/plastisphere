#!/usr/bin/env bash

#SBATCH -A C3SE2025-1-11 -p vera
#SBATCH -n 1
#SBATCH -t 1:00:00
#SBATCH -J mumame_analysis
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/analysis.%J.err
#SBATCH --output=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/analysis.%J.out

###
#
# Date: 2025.03.04
# Author: Felix Blomfelt
#
# Description: 
# 
# Usage: 
# sbatch mumame_analysis.sh
#
###


### Set parameters
# Input directory
INDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Mumame_test/results;

# Output directory
OUTDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Mumame_test/analysis;

# Location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Container/plastisphere.sif;

# Temp files directory variable
WORKING_TMP=$TMPDIR/MUMAME_TMP;

### Purge modules
module purge

# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;
# Copy relevant files to $TMPDIR
cp $INDIR/* $WORKING_TMP 

ls -lah

# Run mumame 
apptainer exec $CONTAINER_LOC Rscript --no-save analyze_mumame_output.R

### Copy all files back
cp -r $WORKING_TMP/* $OUTDIR;
