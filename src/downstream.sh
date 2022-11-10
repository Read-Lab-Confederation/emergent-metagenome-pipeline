#!/bin/bash

# CONDA ENV 
# conda activate emp 

# GET BAM FILE
while getopts b:p:x: flag
do
    case "${flag}" in
        b) bamfile=${OPTARG};;
        p) prefix=${OPTARG};;
        x) pathname=${OPTARG};;
    esac
done
echo "bamfile: $bamfile";

# SORT BAM

bamSort=`echo $pathname $prefix .sorted.bam | sed 's/ //g'`
#echo $bamSort

samtools sort $bamfile -o $bamSort   

# REMOVE DUPLICATES (COULD BE OPTIONAL LATER)
bamRm=`echo $pathname $prefix .sorted.rmdup.bam | sed 's/ //g'`
samtools rmdup $bamSort $bamRm                   

# GET STATS OF BAM 

samtools index $bamRm

#BEFORE DEDUPLICATION STATS
bamSortStat=`echo $pathname $prefix .sorted.stats.tab | sed 's/ //g'`
 samtools stats $bamSort |grep ^SN | cut -f 2- > $bamSortStat
 
#AFTER DEDUPLICATION STATS
bamRmStat=`echo $pathname $prefix .sorted.rmdup.stats.tab | sed 's/ //g'`
samtools stats $bamRm |grep ^SN | cut -f 2- > $bamRmStat

