#!/usr/bin/env bash

# SBATCH -A C3SE2025-1-11 -p vera
# SBATCH -n 10
# SBATCH -t 10:00:00
# SBATCH -J mumame 
# SBATCH --mail-user=blfelix@student.chalmers.se
# SBATCH --mail-type=ALL
# Set the names for the error and output files
# SBATCH --error=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/test_mumame.%J.err
# SBATCH --output=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/test_mumame.%J.out

# ##
#
# Date: 2025.03.04
# Author: Felix Blomfelt
#
# Description: 
# Runs mumame on the *val_1.fq.gz files present in $INDIR, using the database
# located in $DATADIR constructed by mumame_build. 
# It will automatically also use the corresponding *val_2.fq.gz file in the 
# same directory as the first one.
# It will output its *mapping_results files in $OUTDIR. 
#
# Usage: 
# sbatch mumame.sh
#
# ##


### Set parameters
# Input directory
INDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/storeDir/TrimGalore/;

# Database directory
DATADIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Mumame_database/;

# Output directory
OUTDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Mumame_results;

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
cp $DATADIR/mutation_database* $WORKING_TMP 
# Total size approx 63 Gb, needs at least 5 cores for TMPDIR (845 Gb for 64 c)
cp $INDIR/SRR1406*val_1.fq.gz $WORKING_TMP
# DON'T FORGET TO CHANGE LOG NAME AND CORES ABOVE

# Run mumame 
apptainer exec $CONTAINER_LOC mumame -i *_1_val_1.fq.gz -d "mutation_database_3.1.4" -o "mapping_results_3.4"
#apptainer exec $CONTAINER_LOC mumame -i "$INDIR/*val_1.fq.gz" -d mutation_database_3.4 -o "mapping_results"

### Copy all files back
cp -r $WORKING_TMP/mapping_results* $OUTDIR;
