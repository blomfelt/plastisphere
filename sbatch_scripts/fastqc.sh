#!/usr/bin/env bash

#SBATCH -A C3SE2025-1-11 -p vera
#SBATCH -n 4
#SBATCH -t 1:00:00
#SBATCH -J fastqc 
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/job.%J.err
#SBATCH --output=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/job.%J.out

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
NUM_THREADS=6

# Input directory
INDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/data_fastq;

# Output directory
OUTDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/fastqc;

# Location of the container
CONTAINER_LOC=/cephyr/users/blfelix/Vera/thesis/plastisphere.sif;

# Temp files directory variable
WORKING_TMP=$TMPDIR/FASTQC_TMP;

### Purge modules
module purge

# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;
# Copy relevant files to $TMPDIR
# First fastQC:
#cp $INDIR/DRR528401_*.fastq.gz $WORKING_TMP 
#cp $INDIR/DRR528402*.fastq.gz $WORKING_TMP 

ls $INDIR/*.fastq.gz | sed -r 's/^.+\///' | sed -r "s/_[12].fastq.gz//"> all.txt
ls $OUTDIR/*.zip | sed -r 's/^.+\///' | sed "s/_[12]_fastqc.zip//" > done.txt

comm -23 all.txt done.txt > todo.txt

NOT_DONE=`ls $INDIR/*.fastq.gz | grep -f todo.txt | head -n 18`
echo $NOT_DONE
cp $NOT_DONE $WORKING_TMP 

### Run fastQC on all files
#for file in `ls *.fastq.gz`
#do
#   apptainer exec $CONTAINER_LOC fastqc $file -o $WORKING_TMP --threads 6
#done
### Run fastQC on all remaining files
apptainer exec $CONTAINER_LOC fastqc $WORKING_TMP/*fastq.gz -o $OUTDIR --threads $NUM_THREADS
#apptainer exec $CONTAINER_LOC fastqc $INDIR/DRR52840*.fastq.gz -o $WORKING_TMP --threads 6

### Copy relevant files back
#cp $WORKING_TMP/*.zip $OUTDIR;
#cp $WORKING_TMP/*.html $OUTDIR;
cp $WORKING_TMP/*.txt $OUTDIR;


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
