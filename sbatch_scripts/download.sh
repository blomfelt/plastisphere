#!/usr/bin/env bash

#SBATCH -A C3SE2025-1-11 -p vera
#SBATCH -n 1
#SBATCH -t 5:00:00
#SBATCH -J download_data
#SBATCH --mail-user=blfelix@student.chalmers.se
#SBATCH --mail-type=ALL
# Set the names for the error and output files
#SBATCH --error=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/job.%J.err
#SBATCH --output=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/logs/job.%J.out


###
#
# Date: 2025.02.21
# Author: Felix Blomfelt
#
# Description: 
# This script will download the paired reads from the URLs found in $inputFile,
# where each line is a separate URL, 
# e.g. ftp.sra.ebi.ac.uk/vol1/fastq/SRR273/036/SRR27352936/SRR27352936_1.fastq.gz
# It will replace "_1" at the end of the URL with "_2" to get the paired read.
# 
# Usage: 
# sbatch download.sh
#
###


### Set parameters
# Working directory, where the downloaded files will be stored
WORKDIR=/cephyr/NOBACKUP/groups/jbp-mv-waters/felix/data_fastq;

# Temp files directory variable
WORKING_TMP=$TMPDIR/DOWNLOAD_TMP;

# Input file with URLs
inputFile=download.txt

### Purge modules
module purge

# create a temporary directory to store output files
mkdir $WORKING_TMP;
cd $WORKING_TMP;
# Copy in the input
cp /cephyr/NOBACKUP/groups/jbp-mv-waters/felix/$inputFile $WORKING_TMP 

### Script start
# Total files to download
lineCount=`wc -l $inputFile | cut -d" " -f1`

# Loop over all files in the input file
for file1 in `cat $inputFile`
do
    # Create URL for paired read
    file2=`echo $file1 | sed "s/1.fastq.gz/2.fastq.gz/"`
    # Download both files to $WORKDIR
    wget --progress=dot:giga --continue --directory-prefix $WORKDIR --no-clobber $file1 $file2
    # Track how many files have been downloaded
    current=`grep --line-number $file1 $inputFile | cut -d":" -f1`
    echo "Done with $current/$lineCount" 
done

echo "
---------------------
Downloaded all files!
---------------------"

### Copy files back
cp $WORKING_TMP/* $WORKDIR;
