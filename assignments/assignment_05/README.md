Assignment 5, Ambika Elangovan, 10/1/2026

---
## Task 1

$ cd SUPERCOMPUTING/assignments/assignment_05 
$ mkdir scripts
$ mkdir log
$ mkdir data
$ cd data/
$ mkdir raw
$ mkdir trimmed


$ cd ..
$ ll

***output:***
total 4.0K
drwx--x---.  5 aelangovan gzdata440   60 Sep 30 19:06 .
drwx--x---. 10 aelangovan gzdata440 4.0K Sep 23 13:10 ..
drwx------.  4 aelangovan gzdata440   44 Sep 30 19:06 data
drwx------.  2 aelangovan gzdata440   10 Sep 30 19:06 log
drwx------.  2 aelangovan gzdata440   10 Sep 30 19:06 scripts

***making the script files:***
$ nano pipeline.sh
$ cd scripts/
$ nano 01_download_data.sh
$ nano 02_run_fastp.sh
$ cd ..

---

## Task 2

$ nano 01_download_data.sh

***inside nano 01_download_data.sh***
#!/bin/bash
set -ueo pipefail

#1. downloading file
wget https://gzahn.github.io/data/fastq_examples.tar

#2. extracting contents
tar -xvf fastq_examples.tar

#3. putting ALL files in raw directory
mv *fastq.gz ./data/raw/

#4. removing tar file
rm fastq_examples.tar




$ chmod +x 01_download_data.sh

---

## Task 3

*from home*
$ cd programs/

*hopefully following the instructions in teh README correctly from the "download the latest prebuilt binary for Linux users" section:*
$ wget http://opengene.org/fastp/fastp'
$ chmod a+x ./fastp

*checking which version it downloaded*
$ fastp --version
***output:*** fastp 1.3.7

$ echo 'export PATH=$PATH:~/programs/fastp' >> ~/.bashrc

*checking the paths:*
$echo $PATH
*output:*
/opt/conda/bin:/usr/local/slurm-23.11.9/bin:/usr/local/slurm-23.11.9/sbin:/usr/local/slurm-23.11.9/sbank/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/share/Modules/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sciclone/home/aelangovan/programs/:/sciclone/home/aelangovan/programs/fastp

---

## Task 4

$ cd SUPERCOMPUTING/assignments/assignment_05/scripts
$ nano 02_run_fastp.sh


***indsde nano for 02_run_fastp.sh***
#!/bin/bash
set -ueo pipefail

FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}
REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz}

\#putting them in /data/trimmed
FWD_OUT=${FWD_OUT/raw/trimmed}
REV_OUT=${REV_OUT/raw/trimmed}

fastp \
--in1 $FWD_IN \
--out1 $FWD_OUT \
--in2 $REV_IN \
--out2 $REV_OUT \
--json /dev/null \
--html /dev/null \
--trim_front1 8 \
--trim_front2 8 \
--trim_tail1 20 \
--trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20


***outside of nano***
$ chmod +x 02_run_fastp.sh

***testing run_fastp on a file***
$./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz
*output:*
Read1 before filtering:
total reads: 100
total bases: 29768
Q20 bases: 28913(97.1278%)
Q30 bases: 27086(90.9903%)
Q40 bases: 27086(90.9903%)

Read2 before filtering:
total reads: 100
total bases: 29795
Q20 bases: 26624(89.3573%)
Q30 bases: 21779(73.0962%)
Q40 bases: 21779(73.0962%)

Read1 after filtering:
total reads: 99
total bases: 26961
Q20 bases: 26543(98.4496%)
Q30 bases: 25305(93.8578%)
Q40 bases: 25305(93.8578%)

Read2 after filtering:
total reads: 99
total bases: 26988
Q20 bases: 24751(91.7111%)
Q30 bases: 20834(77.1973%)
Q40 bases: 20834(77.1973%)

Filtering result:
reads passed filter: 198
reads failed due to low quality: 2
reads failed due to too many N: 0
reads failed due to too short: 0
reads failed due to adapter dimer: 0
reads with adapter trimmed: 0
bases trimmed due to adapters: 0

Duplication rate: 0%

Insert size peak (evaluated by paired-end reads): 400

JSON report: /dev/null
HTML report: /dev/null

fastp --in1 ./data/raw/6083_001_S1_R1_001.subset.fastq.gz --out1 ./data/trimmed/6083_001_S1_R1_001.subset.trimmed.fastq.gz --in2 ./data/raw/6083_001_S1_R2_001.subset.fastq.gz --out2 ./data/trimmed/6083_001_S1_R2_001.subset.trimmed.fastq.gz --json /dev/null --html /dev/null --trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 --n_base_limit 0 --length_required 100 --average_qual 20
fastp v1.3.7, time used: 0 seconds

---

## Task 5

*(in assignment_05 directory)*
$ nano pipeline.sh

***inside nano for pipeline.sh:***
#!/bin/bash
set -ueo pipefail

\#run `./scripts/01_download_data.sh`
./scripts/01_download_data.sh

\#for loop for `./scripts/02_run_fastp.sh`
for file in ./data/raw/\*\_R1\_\*.fastq.gz
do
./scripts/02_run_fastp.sh $file
done



$ chmod +x pipeline.sh

---

## Task 6

*(still in assignment_05 directory)*

$ cd data/raw
$ rm \*

$ cd ..
$ cd trimmed/
$ rm \*

---

## Task 7

The biggest challenge ended up keeping track of my file paths and the variable names. I kept kind of losing track of where I was and also where I was supposed to be calling scripts from. I think I want to install the tree tool at some point instead of going back and forth between directories and using "ll" to see if what's in there is supposed to be in there.

I think that splitting this into two scripts was a pretty logical way to go about it, because that way we are having each script do a separate task rather than having one big script doing everything. This way, we could keep an eye on where things were messing up if there were any errors. On the other hand, it probably did contribute to me losing my place a bunch of times but that's on me.
