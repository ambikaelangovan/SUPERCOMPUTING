#!/bin/bash
set -ueo pipefail

module load Flye/gcc-11.4.1/2.9.6


rm -rf ./assemblies/assembly_module
mkdir -p ./assemblies/assembly_module

flye --nano-hq ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_module --threads 2 --meta


mv ./assemblies/assembly_module/assembly.fasta ./assemblies/module_assembly.fasta
mv ./assemblies/assembly_module/flye.log ./assemblies/module_flye.log
rm -rf ./assemblies/assembly_module
mkdir -p ./assemblies/assembly_module
mv ./assemblies/module_assembly.fasta ./assemblies/module_flye.log ./assemblies/assembly_module/


module unload Flye/gcc-11.4.1/2.9.6
