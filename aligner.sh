#!/bin/bash

#fastq1 $1
#input fastq1 $2
#sample id $3


SECONDS=0
dir=$(pwd)
reference_file=Homo_sapiens_assembly38

mkdir $dir/outputs/$3
mkdir $dir/temp

cd $dir/reference/

if [[ ! -f $reference_file.fasta.amb ]] || [[ ! -f $reference_file.fasta.ann ]] || [[ ! -f $reference_file.fasta.bwt ]] || [[ ! -f $reference_file.fasta.pac ]] || [[ ! -f $reference_file.fasta.sa ]]; then
echo "Creating index files."
#Creates index files of reference
bwa index $dir/reference/$reference_file.fasta
else
echo "index files are already exist."
fi

if [[ ! -f $reference_file.fasta.fai ]]; then
echo "Creating .fai file."
#creates .fai file of reference
samtools faidx -f $dir/reference/$reference_file.fasta
else
echo ".fai file is already exist."
fi

cd $dir

#Trims the adapter sequences
trimmomatic PE -threads 10 $dir/data/$3/$1.fastq.gz $dir/data/$3/$2.fastq.gz $dir/temp/$1_R1_trimmed.fq.gz $dir/temp/$1_R1_unpaired.fq.gz $dir/temp/$2_R2_trimmed.fq.gz $dir/temp/$2_R2_unpaired.fq.gz ILLUMINACLIP:$dir/adapters/NexteraPE-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36


#Creates .sam file
bwa mem -t 10 -R "@RG\tID:$3\tSM:$3\tPL:Illumina" $dir/reference/$reference_file.fasta $dir/temp/$1_R1_trimmed.fq.gz $dir/temp/$2_R2_trimmed.fq.gz > $dir/temp/$3.sam

samtools fixmate -@ 10 -m $dir/temp/$3.sam $dir/temp/$3.fixmate.bam

samtools sort -@ 10 $dir/temp/$3.fixmate.bam -o $dir/temp/$3.sorted.bam 

samtools markdup -@ 10 -r $dir/temp/$3.sorted.bam $dir/temp/$3.markdup.bam

samtools index $dir/temp/$3.markdup.bam

cp $dir/temp/$3.markdup.bam.bai $dir/outputs/$3/$3.bam.bai

cp $dir/temp/$3.markdup.bam $dir/outputs/$3/$3.bam

#rm -r $dir/temp

duration=$SECONDS
echo "Aligning is finished. $(($duration / 3600)):$((($duration % 3600) / 60)):$(($duration % 60))"