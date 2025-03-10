#!/usr/bin/env bash

# SBATCH -A C3SE2025-1-11 -p vera
# SBATCH -n 5
# SBATCH -t 1:00:00
# SBATCH -J mumame 
# SBATCH --mail-user=blfelix@student.chalmers.se
# SBATCH --mail-type=ALL
# Set the names for the error and output files
# SBATCH --error=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/mumame.%J.err
# SBATCH --output=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/mumame.%J.out

# ##
#
# Date: 2025.03.04
# Author: Felix Blomfelt
#
# Description: 
#
# Usage: 
# sbatch mumame.sh
#
# ##


### Set parameters
# Input directory
INDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/storeDir/TrimGalore/;

# Database directory
DATADIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Mumame_test/;

# Output directory
OUTDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Mumame_test/results;

# Location of the container
CONTAINER_LOC=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Container/plastisphere_usearch64.sif;

# Temp files directory variable
WORKING_TMP=$TMPDIR/MUMAME_TMP;

### Purge modules
module purge

# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;
# Copy relevant files to $TMPDIR
cp $INDIR/SRR14061754_1_val_1.fq.gz $WORKING_TMP 
#cp $INDIR/SRR3401475_1_val_1.fq.gz $WORKING_TMP 
cp $DATADIR/mutation_database* $WORKING_TMP 

# Run mumame 
apptainer exec $CONTAINER_LOC mumame -i SRR14061754_1_val_1.fq.gz -d "mutation_database_3.1.4" -o "mapping_results_3.1.4"
#apptainer exec $CONTAINER_LOC mumame -i "$INDIR/*val_1.fq.gz" -d mutation_database_3.4 -o "mapping_results"

### Copy all files back
cp -r $WORKING_TMP/mapping_results* $OUTDIR;
