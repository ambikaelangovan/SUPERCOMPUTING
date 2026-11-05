Ambika Elangovan, assignment 7, November 5th

---

## Task 1:

cd assignment_07
mkdir data
cd data/
mkdir clean
mkdir dog_reference
mkdir raw
cd ..
mkdir output
mkdir scripts

---

## Task 2:

- used the Advance Search option on the SRA website
	- search string: (((((((metagenomic[Source]) AND wgs[Strategy]) AND random[Selection]) AND illumina[Platform]) AND paired[Layout]) AND coral)) AND seawater 
		- (stole the coral reef idea sorry.....)
- sent results to Run Selector
- sorted by Bytes (so smaller ones were at the top)
- selected 10 and downloaded the Metadata
- used FileZilla to copy from local downloads to the assignment_07/data (on the HPC)


**script: (called 01_download_data.sh)**
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

---

## Task 3:

**script: (called 02_clean_reads.sh)**
  GNU nano 5.6.1                 02_clean_reads.sh                 Modified
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

---

## Task 4:

**script: (03_map_reads.sh)**
#!/bin/bash
set -ueo pipefail

cd "$(dirname "$0")/.."

mkdir -p output

MEM=40g
THREADS=${SLURM_CPUS_PER_TASK:-4}


bbmap.sh ref=data/dog_reference/dog_reference_genome.fna path=data/dog_refer>


for fwd in data/clean/*_1.fastq.gz
do
    rev=${fwd/_1.fastq.gz/_2.fastq.gz}
    sample=$(basename "$fwd" _1.fastq.gz)

    bbmap.sh in1="$fwd" in2="$rev" out=output/${sample}.sam \
             path=data/dog_reference minid=0.95 threads=$THREADS -Xmx$MEM
done

---

## Task 5:

**added a line to the for loop in 03_map_reads.sh:**
samtools view -h -F 4 output/${sample}.sam > output/${sample}_dog-matches.sam
- should only keep reads mapped onto dog genome
- -h keeps SAM header

---

## Task 6:

**assignment_7_pipeline.slurm:**
  GNU nano 5.6.1            assignment_7_pipeline.slurm
#!/bin/bash
#SBATCH --job-name=assignment_7
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=48G
#SBATCH --time=24:00:00
#SBATCH --output=/sciclone/home/aelangovan/SUPERCOMPUTING/assignments/assignment_07/output/assignment_7.out
#SBATCH --error=/sciclone/home/aelangovan/SUPERCOMPUTING/assignments/assignment_07/output/assignment_7.err

#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=aelangovan@wm.edu

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate dogmap

set -ueo pipefail

cd "$SLURM_SUBMIT_DIR"

bash scripts/01_download_data.sh
bash scripts/02_clean_reads.sh
bash scripts/03_map_reads.sh

---

## Task 7:

**from output of "sacct -j 597944 --format=JobID,JobName,State,Elapsed,MaxRSS"**
- the job (successfully, hopefully) completed
- time elapsed = 1:47:44
- Maximum Resident Set Size = 50329528K
	- approximately 48GB which i what i specified

**contents of assingment_7.out:**
```
Archive:  data/dog_reference/dog.zip
  inflating: data/dog_reference/README.md
  inflating: data/dog_reference/ncbi_dataset/data/assembly_data_report.jsonl
  inflating: data/dog_reference/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna
  inflating: data/dog_reference/ncbi_dataset/data/dataset_catalog.json
  inflating: data/dog_reference/md5sum.txt
```
- shows that the dog genome was unzipped
	- (right --refernce (GCF_011100685.1)!!!!)


**going through assignment_7.err:**
*(i looked up the best way to go about this instead of manually reading throuhg the whole file):*
grep -inE "error|exception|killed|not found|no such file|warning" output/assignment_7.err 
- only lines that showed up were about "Error Rate" and "WARNING: Using incubator modules"

---

## Task 8:

module load miniforge3
conda activate dogmap

cut -d ',' -f1 data/SraRunTable.csv | tail
grep -m2 '"total_reads"' output/<Sample_ID>_fastp.json | tail
- using the last one
samtools view -c output/<Sample_ID>_dog-matches.sam

| Sample ID   | Total Reads | Dog-Mapped Reads |
| ----------- | ----------- | ---------------- |
| ERR770995   | 5454866     | 232              |
| ERR771010   | 2503300     | 143              |
| ERR771011   | 3220002     | 331              |
| SRR33438237 | 234818      | 158              |
| SRR33438238 | 5459518     | 602              |
| SRR33438277 | 5117540     | 3466             |
| SRR33438278 | 70656       | 16               |
| SRR33438329 | 61906       | 24               |
| SRR33438330 | 888612      | 175              |
| SRR33438332 | 762594      | 35               |
- also I'm pretty sure that both of the counts include the forward AND reverse reads, so each one is 2????

---

## Task 9:

**descriptions:**
- downloading the data: scripts/01_download_data.sh
- cleaning the downloaded data: scripts/02_clean_reads.sh
- mapping and extracting the dog reads: scripts/03_map_reads.sh

**reflection:**
- challenges:
	- navigating the ncbi database was kind of hard!!! advanced search saved me
	- i spent like 20 minutes trying to `conda activate dogmap` and couldn't figure out why it wasn't working but then I just had to create the environment with the tools whoops
	- okay this was stupid but in my pipeline.slurm script header, i sent the output and error to a folder called assignment_7/output instead of assignment_07/output.... this was irritating but i just moved the .err and .out files to the right folder and deleting the other one
- what I learned:
	- using the SRA search and the run selector and how to build my own set of metadata files
	- SAM flags
