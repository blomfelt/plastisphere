#!/usr/bin/env bash

###
#
# Date: 2025.03.11
# Author: Felix Blomfelt
#
# Description: 
# This script takes in beginning_filenames.txt, where each line is the 
# beginning of the filenames which will be sent to mumame.sh.
# This is done in order to be able to run several jobs in parallel, each unique
# and not too large for the cores used. 
# You may obtain a list of this form using:
# ls *_1_val_1.fq.gz | sed -e "s/[0-9]\{2\}_1_val_1.fq.gz//" | uniq
# And the size of each group may be found using
# for file in $(ls *_1_val_1.fq.gz | sed -e "s/[0-9]\{2\}_1_val_1.fq.gz//" | \
# uniq); do du -ch $file*gz | grep "total"; done
#
# Usage: 
# split_mumame.sh
#
###
for files in $(cat beginning_filenames.txt)
do
   sbatch sbatch_scripts/mumame.sh $files
done
