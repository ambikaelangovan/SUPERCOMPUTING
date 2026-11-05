#!/bin/bash
set -ueo pipefail

cd "$(dirname "$0")/.."

mkdir -p output

MEM=40g
THREADS=${SLURM_CPUS_PER_TASK:-4}


bbmap.sh ref=data/dog_reference/dog_reference_genome.fna path=data/dog_reference -Xmx$MEM

for fwd in data/clean/*_1.fastq.gz
do
    rev=${fwd/_1.fastq.gz/_2.fastq.gz}
    sample=$(basename "$fwd" _1.fastq.gz)

    bbmap.sh in1="$fwd" in2="$rev" out=output/${sample}.sam \
             path=data/dog_reference minid=0.95 threads=$THREADS -Xmx$MEM

    
    samtools view -h -F 4 output/${sample}.sam > output/${sample}_dog-matches.sam
done
