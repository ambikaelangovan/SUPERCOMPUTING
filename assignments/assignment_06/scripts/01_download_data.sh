#!/bin/bash
set -ueo pipefail

# downloading raw ONT data directly into ./data:
mkdir -p ./data
wget -O ./data/SRR33939694.fastq.gz "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"
