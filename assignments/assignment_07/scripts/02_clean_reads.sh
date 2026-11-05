#!/bin/bash
set -ueo pipefail

cd "$(dirname "$0")/.."

for fwd in data/raw/*_1.fastq.gz
do
    rev=${fwd/_1.fastq.gz/_2.fastq.gz}
    sample=$(basename "$fwd" _1.fastq.gz)
    out_fwd=data/clean/${sample}_1.fastq.gz
    out_rev=data/clean/${sample}_2.fastq.gz

    fastp --in1 "$fwd" --in2 "$rev" \
          --out1 "$out_fwd" --out2 "$out_rev" \
          --detect_adapter_for_pe \
          --json output/${sample}_fastp.json \
          --html output/${sample}_fastp.html
done
