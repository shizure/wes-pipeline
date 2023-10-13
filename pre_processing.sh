#!/bin/bash

#sample id $1

SECONDS=0
reference_file=Homo_sapiens_assembly38
dir=$(pwd)
#mkdir $dir/temp

cd $dir/reference/

if [[ ! -f $reference_file.dict ]]; then
echo "Creating .dict file."
#Creates .dic file of reference
gatk CreateSequenceDictionary -R $dir/reference/$reference_file.fasta
else
echo ".dic file is already exist."
fi


cd $dir

#cp $dir/outputs/$1/$2/$2.markdup.bam $dir/temp/$1.markdup.bam

gatk BaseRecalibrator -R $dir/reference/$reference_file.fasta --known-sites $dir/reference/Homo_sapiens_assembly38.dbsnp138.vcf --known-sites $dir/reference/Homo_sapiens_assembly38.known_indels.vcf.gz -I $dir/temp/$1.bam -O $dir/temp/$1.table

gatk ApplyBQSR -R $dir/reference/$reference_file.fasta -I $dir/temp/$1.bam -bqsr $dir/temp/$1.table -O $dir/temp/$1_recall.bam

samtools index $dir/temp/$1_recall.bam

gatk HaplotypeCaller -R $dir/reference/$reference_file.fasta -D $dir/reference/Homo_sapiens_assembly38.dbsnp138.vcf --native-pair-hmm-threads 10 -I $dir/temp/$1_recall.bam -O $dir/outputs/$1/$1.recalibrated_snps_raw_indels.vcf

rm -r $dir/temp

duration=$SECONDS
echo "$(($duration / 3600)):$((($duration % 3600) / 60)):$(($duration % 60))"