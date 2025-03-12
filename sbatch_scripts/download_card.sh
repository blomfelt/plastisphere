#!/usr/bin/env bash

###
#
# Date: 2025.03.12
# Author: Felix Blomfelt
#
# Description: 
# This script downloads version 4.0.0 of the Comprehensive Antibiotic 
# Resistance Database 
#
# Usage: 
# split_mumame.sh
#
###

# Download the compressed file
wget https://card.mcmaster.ca/download/0/broadstreet-v4.0.0.tar.bz2

# Create a directory to store the data in
mkdir card-data-4.0

# Unzip it and remove the original file
tar -xv --directory=card-data/ -f broadstreet-v4.0.0.tar.bz2 
rm broadstreet-v4.0.0.tar.bz2 	
