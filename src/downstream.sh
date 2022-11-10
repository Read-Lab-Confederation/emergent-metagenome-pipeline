#!/bin/bash

# CONDA ENV 
# conda activate emp 

# GET BAM FILE
while getopts b:a:f: flag
do
    case "${flag}" in
        b) bamfile=${OPTARG};;
        a) age=${OPTARG};;
        f) fullname=${OPTARG};;
    esac
done
echo "bamfile: $bamfile";


