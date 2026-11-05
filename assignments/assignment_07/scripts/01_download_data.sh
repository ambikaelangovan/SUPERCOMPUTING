#!/bin/bash
set -ueo pipefail

cd "$(dirname "$0")/.."


for run in $(cut -d ',' -f1 data/SraRunTable.csv | tail -n +2)
do
    fasterq-dump "$run" --split-files -O data/raw
done
gzip data/raw/*.fastq


datasets download genome taxon "Canis familiaris" --reference --include genome --filename data/dog_reference/dog.zip
unzip -o data/dog_reference/dog.zip -d data/dog_reference
mv data/dog_reference/ncbi_dataset/data/*/*.fna data/dog_reference/dog_reference_genome.fna

rm -rf data/dog_reference/dog.zip data/dog_reference/ncbi_dataset data/dog_reference/*.md data/dog_reference/*.json
