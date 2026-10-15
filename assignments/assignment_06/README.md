Assignment 6, Ambika Elangovan, 10/15/2026

---

# Task 1:

**ON THE HPC**

cd SUPERCOMPUTING/assignments/assignment_06
mkdir assemblies
mkdir data
mkdir scripts

cd assemblies/
mkdir assembly_conda assembly_local assembly_module

---


# Task 2:

cd scripts/
nano 01_download_data.sh

***inside nano for 01_download_data.sh:***
	#!/bin/bash
	set -ueo pipefail
	# downloading raw ONT data directly into ./data:
	mkdir -p ./data
	wget -O ./data/SRR33939694.fastq.gz "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"


chmod +x 01_download_data.sh


cd ../
./scripts/01_download_data.sh
	***output:***
		--2026-10-14 22:58:11--  https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1
		Resolving zenodo.org (zenodo.org)... 188.185.43.153, 137.138.153.219, 188.184.98.114, ...
		Connecting to zenodo.org (zenodo.org)|188.185.43.153|:443... connected.
		HTTP request sent, awaiting response... 200 OK
		Length: 53503361 (51M) [application/octet-stream]
		Saving to: ‘./data/SRR33939694.fastq.gz’
		./data/SRR33939694.fastq.gz     100%[======================================================>]  51.02M  1.33MB/s    in 44s
		2026-10-14 22:58:56 (1.17 MB/s) - ‘./data/SRR33939694.fastq.gz’ saved [53503361/53503361]


---


# Task 3:

cd scripts
nano 02_flye_2.9.6_manual_build.sh

***inside nano for 02_flye_2.9.6_manual_build.sh:***
	#!/bin/bash
	set -ueo pipefail
	cd ~/programs
	# copied from Flye INSTALL.md
	git clone https://github.com/fenderglass/Flye
	cd Flye
	make
	# checking!!!! the version
	~/programs/Flye/bin/flye --version

chmod +x 02_flye_2.9.6_manual_build.sh

export PATH="\$HOME/programs/Flye/bin:$PATH"

which flye
	***output:***
		~/programs/Flye/bin/flye

flye --version
	***output:***
		2.9.6-b1802

---

ask 4

nano 02_flye_2.9.6_conda_install.sh

***inside nano for :***
	#!/bin/bash
	set -ueo pipefail
	# initializing
	module load miniforge3
	source "$(conda info --base)/etc/profile.d/conda.sh"
	# building conda (mambda) enironment
	mamba create -y -n flye-env -c conda-forge -c bioconda flye=2.9.6
	\#activating
	conda activate flye-env
	\#testing
	flye -v
	\#documenting environment
	conda env export --no-builds > ./flye-env.yml
	\#deactivating
	conda deactivate


cd ..
./scripts/02_flye_2.9.6_conda_install.sh

***output (there was a lot so i took screenshots. i have no idea how to include them in a markdown file without actually uploading the pictures. they exist i promise!)***



***checking it properly made the yaml file:***
head -10 flye-env.yml
	***output:***
		name: flye-env
		channels:
		  - bioconda
		  - conda-forge
		dependencies:
		  - _openmp_mutex=4.5
		  - bzip2=1.0.8
		  - ca-certificates=2026.7.22
		  - flye=2.9.6
		  - ld_impl_linux-64=2.46.1


### Q&A:
- Where should this script go?
	- inside assignment_06/scripts
- What point should its relative file paths start from?
	- trying to run the script from the assingment_06 directory, so there 
- What version did you install via conda/mamba?
	- 2.9.6-b1802

---


# Task 5

***(inside the flye environemtn):***
flye --nano-hq ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_conda --threads 2 --meta
	***output: (more images...sorry...)***
- had to change the threads from 6 to 2. got kicked off twice while trying with 6 and then once when trying with 4..... 2 feels safe
- --nano-hq: ONT high-quality reads
- --out-dir: Output directory
- --meta: metagenome / uneven coverage mode
	- (in case there was more than one i think.... this is the best flag i found in the help for this case but I'm not 100% sure)
- What's the expected genome size? **(i looked this up)**
	- 3.39 kb to about 386.44 kb (from [NIH article](https://pmc.ncbi.nlm.nih.gov/articles/PMC9041448/))


---

# Task 6

## Task 6A
nano 03_run_flye_conda.sh

**inside nano for 03_run_flye_conda.sh**
	#!/bin/bash
	set -ueo pipefail
	\#loading minifogre and acticating flye-env environemt
	module load miniforge3
	source "$(conda info --base)/etc/profile.d/conda.sh"
	conda activate flye-env
	\#cleaning up file blaot- making  sure it's all empty from my previous messing around
	rm -rf ./assemblies/assembly_conda
	mkdir -p ./assemblies/assembly_conda
	\#command that hopeully runs on the login node
	flye --nano-hq ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_conda --threads 2 --meta
	\#okay i might have done in this in the worst possible way
	\# moving the files it made up a directory, deleting the ENTIRE messey folder, and then putting back in two files
	\# sorry
	mv ./assemblies/assembly_conda/assembly.fasta ./assemblies/conda_assembly.fasta
	mv ./assemblies/assembly_conda/flye.log ./assemblies/conda_flye.log
	rm -rf ./assemblies/assembly_conda
	mkdir -p ./assemblies/assembly_conda
	mv ./assemblies/conda_assembly.fasta ./assemblies/conda_flye.log ./assemblies/assembly_conda/
	conda deactivate

chmod +x 03_run_flye_conda.sh


***after running** `./scripts/03_run_flye_conda.sh`, **checking what exactly is in the directory:***
ll assemblies/assembly_conda/
	***output:***
		total 140K
		drwx------. 2 aelangovan gzdata440  68 Oct 15 01:00 .
		drwx------. 5 aelangovan gzdata440  89 Oct 15 01:00 ..
		-rw-------. 1 aelangovan gzdata440 99K Oct 15 01:00 conda_assembly.fasta
		-rw-------. 1 aelangovan gzdata440 39K Oct 15 01:00 conda_flye.log
		
(yay!!!! i think)


## Task 6B

nano 03_run_flye_module.sh

***inside 03_run_flye_module.sh:***
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

chmod +x 03_run_flye_module.sh

***after running `./scripts/03_run_flye_conda.sh`:***
ll assemblies/assembly_module/
	***output:***
		total 140K
		drwx------. 2 aelangovan gzdata440  70 Oct 15 01:15 .
		drwx------. 5 aelangovan gzdata440  89 Oct 15 01:15 ..
		-rw-------. 1 aelangovan gzdata440 99K Oct 15 01:15 module_assembly.fasta
		-rw-------. 1 aelangovan gzdata440 39K Oct 15 01:15 module_flye.log


## Task 6C

nano 03_run_flye_local.sh

***inside nano for 03_run_flye_local.sh:***
	#!/bin/bash
	set -ueo pipefail
	export PATH="\$HOME/programs/Flye/bin:$PATH"
	rm -rf ./assemblies/assembly_local
	mkdir -p ./assemblies/assembly_local
	flye --nano-hq ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_local --threads 2 --meta
	mv ./assemblies/assembly_local/assembly.fasta ./assemblies/local_assembly.fasta
	mv ./assemblies/assembly_local/flye.log ./assemblies/local_flye.log
	rm -rf ./assemblies/assembly_local
	mkdir -p ./assemblies/assembly_local
	mv ./assemblies/local_assembly.fasta ./assemblies/local_flye.log ./assemblies/assembly_local/

chmod +x 03_run_flye_local.sh

***after running `./scripts/03_run_flye_local.sh`:***
ll ./assemblies/assembly_local/
	***output:***
		total 140K
		drwx------. 2 aelangovan gzdata440  68 Oct 15 01:41 .
		drwx------. 5 aelangovan gzdata440  89 Oct 15 01:41 ..
		-rw-------. 1 aelangovan gzdata440 99K Oct 15 01:41 local_assembly.fasta
		-rw-------. 1 aelangovan gzdata440 39K Oct 15 01:41 local_flye.log


---

# Task 7

tail -n 10 ./assemblies/assembly\_\*/\*\_flye.log

- all of the scripts ended up wiht the same statistics of the sequence (length, fragments, fragments n50, largest frg, scaffolds, mean coverage)
- "Final assembly" paths are different by design
- everything else looks the same!!!!


---

# Task 8

nano pipeline.sh

***inside nano pipeline.sh***
	#!/bin/bash
	set -ueo pipefail
	\#downloading raw ONT data
	bash scripts/01_download_data.sh
	\#setting up Flye
	scripts/02_flye_2.9.6_manual_build.sh
	scripts/02_flye_2.9.6_conda_install.sh
	\#running in each environemnt
	bash scripts/03_run_flye_conda.sh
	bash scripts/03_run_flye_module.sh
	bash scripts/03_run_flye_local.sh
	\#comparison
	tail -n 10 ./assemblies/assembly_*/*_flye.log

$chmod +x pipeline.sh

./scripts/pipeline.sh

---

# Task 9

rm -rf ./data ./assemblies ./flye-env.yml
rm -rf ~/programs/Flye
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"
$conda env remove -y -n flye-env
./pipeline.sh

(it worked!!!! i think)

---

# How to run pipeline.sh

- from assignment_06, run ./pipeline.sh
	- should run from the beginning to end without any prompts
- what it does:
	1. ` 01_download_data.sh`: creates `./data/` directory and downloads the raw ONT `SRR33939694.fastq.gz` from the provided link
	2.  `02_flye_2.9.6_manual_build.sh`: clones Flye from GitHub page into `~/programs/Flye` and compiles it locally
	3. `02_flye_2.9.6_conda_install.sh`: creates the conda environment `flye-env` using mamba. exports it to `flye-env.yml`
	4. `03_run_flye_conda.sh`: assembles the data using Flye from the conda environment
	5.  `03_run_flye_module.sh`: assembles the data using Flye from the HPC module
	6.  `03_run_flye_local.sh`: assembles the data using the locally built Flye
	7.  the compatison in `pipeline.sh`: prints the last 10 lines of each Flye log so all three runs can be compared
- each version uses the command `flye --nano-hq ./data/SRR33939694.fastq.gz --out-dir ./assemblies/assembly_<method> --threads 2 --meta`



# Reflection
- challanges:
	- i actually initially did tasks 1 and 2 on my local computer but that was a quick fix
	- i kept getting kicked off the login node when trying to run Flye with 6 threads and also with 4. I ended up with 2 threads
	- there were a lot of small things i kepts going back between scripts to edit/fix but it was more tedious than anything
- learned:
	- installing the same tool three ways
	- learnt a lot from the Flye help documentation
	- how to deal with overloading the login node
	- thought it was really cool that doing this three different ways produced the same results. i think i'll make sure to have some sort of summary command at the end of all of my workflows (like the comparison one here)
- different methods:
	- module: easiest one for me I think. it only required one module load line and there nothing to install. it was set up for the HPC though so it's only usable there
	- conda: good for if we want a specific version and the .yml file makes it reproducible which i know is important
	- local: gives us full control!
	  
	- i think that i prefer the module method because it was the simplest and just worked the first time
	- for next time, i think it is definitely worth it to check for the module being available first.
