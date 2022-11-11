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

# PULL OUT READS FROM BAM 

##  MAPPED READS

bamMap=`echo $pathname $prefix _only-mapped.sorted.rmdup.bam | sed 's/ //g'`
samtools view -b -F 4 $bamRm -o $bamMap

# CREATE FASTQ FROM BAM (paried commented out)
fqMap=`echo $pathname $prefix _only-mapped_sorted-rmdup.fastq | sed 's/ //g'`
fq1Map=`echo $pathname $prefix _only-mapped_sorted-rmdup_R1.fastq | sed 's/ //g'`
fq2Map=`echo $pathname $prefix _only-mapped_sorted-rmdup_R2.fastq | sed 's/ //g'`

bedtools bamtofastq -i $bamMap -fq $fqMap
#bedtools bamtofastq -i $bamMap -fq $fq1Map -fq2 $fq2Map

# CLEAN UP OF INTERMEDIATES

# REMOVE bamMap

bamIndex=`echo $pathname $prefix .sorted.rmdup.bam.bai | sed 's/ //g'`
rm $bamMap $bamRm $bamIndex $bamSort

 
# NOTES FOR FURTHER DEV:
 
# Pull out the unmapped pairs of mapped reads 
# output only paired reads into two separate files (R1 and R2 for pairs)

