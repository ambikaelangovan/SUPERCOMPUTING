#!/bin/bash
set -ueo pipefail


#loading minifogre and acticating flye-env environemt
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate flye-env


#cleaning up file blaot- making  sure it's all empty from my previous messing around
rm -rf ./assemblies/assembly_conda
mkdir -p ./assemblies/assembly_conda

#command that hopeully runs on the login node 
flye --nano-hq ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_conda --threads 2 --meta


#okay i might have done in this in the worst possible way
# moving the files it made up a directory, deleting the ENTIRE messey folder, and then putting back in two files
# sorry
mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/conda_assembly.fasta
mv ./assemblies/assembly_conda/flye.log ./assemblies/conda_flye.log
rm -rf ./assemblies/assembly_conda
mkdir -p ./assemblies/assembly_conda
mv ./assemblies/conda_assembly.fasta ./assemblies/conda_flye.log ./assemblies/assembly_conda/

conda deactivate
