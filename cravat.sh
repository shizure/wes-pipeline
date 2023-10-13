#!/bin/bash

#sample id $1

dir=$(pwd)

oc run $dir/outputs/$1/$1.recalibrated_snps_raw_indels.vcf -d $dir/temp/ -l hg38 -a cadd_exome clinvar dbsnp gerp gnomad go ncbigene omim revel -t csv

cp $dir/temp/$1.recalibrated_snps_raw_indels.vcf.variant.csv $dir/ouputs/$1/$1.csv

rm -r $dir/temp