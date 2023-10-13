#!/bin/bash

SECONDS=0
dir=$(pwd)

cd $dir
bash annovar.sh FMS14 FMS1415

cd $dir
bash annovar.sh FMS14 FMS1404

cd $dir
bash annovar.sh FMS16 FMS1610

cd $dir
bash annovar.sh ETT13 ETT13


duration=$SECONDS
echo "Process is completed. $(($duration / 3600)):$((($duration % 3600) / 60)):$(($duration % 60))"