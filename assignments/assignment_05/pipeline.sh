#!/bin/bash
set -ueo pipefail


#run `./scripts/01_download_data.sh`
./scripts/01_download_data.sh


#for loop for `./scripts/02_run_fastp.sh`
for file in ./data/raw/*_R1_*.fastq.gz
do
./scripts/02_run_fastp.sh $file
done
