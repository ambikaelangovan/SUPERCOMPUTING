#!/bin/bash
set -ueo pipefail


#downloading file
wget https://gzahn.github.io/data/fastq_examples.tar


#extracting contents
tar -xvf fastq_examples.tar



#putting ALL files in raw directory
mv *fastq.gz ./data/raw/


#removing tar file
rm fastq_examples.tar


