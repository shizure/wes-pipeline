#!/bin/bash
#fastq1 $1
#fastq2 $2
#sample id $3
SECONDS=0
dir=$(pwd)
echo $dir
cd $dir
bash aligner.sh $1 $2 $3
bash pre_processing.sh $3
bash cravat.sh $3
cd ~
duration=$SECONDS
echo "Process is completed. $(($duration / 3600)):$((($duration % 3600) / 60)):$(($duration % 60))"