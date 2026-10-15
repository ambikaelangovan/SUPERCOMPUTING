#!/bin/bash
set -ueo pipefail

export PATH="$HOME/programs/Flye/bin:$PATH"

rm -rf ./assemblies/assembly_local
mkdir -p ./assemblies/assembly_local

flye --nano-hq ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_local --threads 2 --meta

mv ./assemblies/assembly_local/assembly.fasta ./assemblies/local_assembly.fasta
mv ./assemblies/assembly_local/flye.log ./assemblies/local_flye.log
rm -rf ./assemblies/assembly_local
mkdir -p ./assemblies/assembly_local
mv ./assemblies/local_assembly.fasta ./assemblies/local_flye.log ./assemblies/assembly_local/
