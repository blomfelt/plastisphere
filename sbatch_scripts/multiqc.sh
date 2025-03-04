#!/usr/bin/env bash

#SBATCH -A C3SE2025-1-11 -p vera
#SBATCH -n 1
#SBATCH -t 5:00:00
#SBATCH -J multiqc 
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=/cephyr/NOBACKUP/groups/jbp/felix/logs/job.%J.err
#SBATCH --output=/cephyr/NOBACKUP/groups/jbp/felix/logs/job.%J.out

###
#
# Date: 2025.02.25
# Author: Felix Blomfelt
#
# Description: 
# This script will run fastqc on all `.fastq.gz` files in $INDIR
# and save the output files (.zip and .html) from fastqc in $OUTDIR
# 
# Usage: 
# sbatch download.sh
#
###


### Set parameters
# Input directory
INDIR=/cephyr/NOBACKUP/groups/jbp/felix/fastqc;

# Output directory
OUTDIR=/cephyr/NOBACKUP/groups/jbp/felix/multiqc;

# Location of the container
CONTAINER_LOC=/cephyr/users/blfelix/Vera/thesis/plastisphere.sif;

# Temp files directory variable
WORKING_TMP=$TMPDIR/MULTIQC_TMP;

### Purge modules
module purge

# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;
# Copy relevant files to $TMPDIR
# First fastQC:
#cp $INDIR/*.fastqc.zip $WORKING_TMP 

# Run multiqc on all fastqc files in $INDIR
apptainer exec $CONTAINER_LOC multiqc --force $INDIR/*fastqc.zip

### Copy relevant files back
cp -r $WORKING_TMP/multiqc* $OUTDIR;


# Refs: 
# C3SE container use: https://www.c3se.chalmers.se/documentation/applications/containers/
# IQ-TREE Manual: http://www.iqtree.org/doc/iqtree-doc.pdf
# -s is the option to specify the name of the alignment file that is always required by IQ-TREE to work.
# -m is the option to specify the model name to use during the analysis. 
# The special MFP key word stands for ModelFinder Plus, which tells IQ-TREE to perform ModelFinder 
# and the remaining analysis using the selected model.
# Here, the model to use has been pre-selected: LG+R5
# To make this reproducible, need to use -seed option to provide a random number generator seed.
# -wbtl Like -wbt but bootstrap trees written with branch lengths. DEFAULT: OFF
# -T AUTO: allows IQ-TREE to auto-select the ideal number of threads
# -ntmax: set the maximum number of threads that IQ-TREE c use
