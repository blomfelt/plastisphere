#!/usr/bin/env bash

#SBATCH -A C3SE2025-1-11 -p vera
#SBATCH -n 10
#SBATCH -t 5:00:00
#SBATCH -J mumame_build 
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/build.%J.err
#SBATCH --output=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/build.%J.out

###
#
# Date: 2025.03.03
# Author: Felix Blomfelt
#
# Description: 
# Runs mumame_build on the card-database you define in $INDIR, and place the 
# resulting mutation_database* files in $OUTDIR.
# Here it will use protein_fasta_protein_variant_model.fasta and snps.txt
# to create the database. 
# 
# Usage: 
# sbatch mumame_build.sh
#
###


### Set parameters
# Input directory
#INDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/card-data/;
INDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/card-data-3.4/;

# Output directory
OUTDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/Mumame_database;

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
cp $INDIR/protein_fasta_protein_variant_model.fasta $WORKING_TMP 
cp $INDIR/snps.txt $WORKING_TMP 

# Run multiqc on all fastqc files in $INDIR
apptainer exec $CONTAINER_LOC mumame_build -i protein_fasta_protein_variant_model.fasta -m snps.txt -d 16 -o "mutation_database_3.4"

### Copy relevant files back
cp -r $WORKING_TMP/mutation_database* $OUTDIR;
