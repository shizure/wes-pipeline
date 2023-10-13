#!/bin/bash

#sample id $1
#patient id $2

SECONDS=0

dir=$(pwd)

cd  $dir/annovar/

perl convert2annovar.pl -includeinfo -allsample -withzyg -format vcf4 $dir/outputs/$1/$2/$2.recalibrated_snps_raw_indels.vcf -outfile annovar

cp annovar.$2.avinput $dir/outputs/$1/$2/$2.avinput

rm annovar.$2.avinput

perl table_annovar.pl $dir/outputs/$1/$2/$2.avinput humandb/ -buildver hg38 -out $dir/outputs/$1/$2/$2 -protocol refGene,avsnp150,clinvar_20221231,gnomad312_genome,revel,dbnsfp42a,ALL.sites.2015_08 -operation gx,f,f,f,f,f,f -nastring . -remove -polish -xref example/gene_xref.txt --otherinfo 
#--vcfinput

cd $dir/outputs/$1/$2

echo "Excel Table is being created."

python $dir/annovar/convert2xlsx.py $2

cd $dir

duration=$SECONDS
echo "Annotation is finished. $(($duration / 3600)):$((($duration % 3600) / 60)):$(($duration % 60))"