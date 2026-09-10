# Assignment 2, Ambika Elangovan, September 10 2026

### Task 1: setting up the HPC
*(already set up in class, including: downloading the global vpn, logging into bora.sciclone, creating the bora alias, cloning SUPERCOMPUTING repository into HPC)* \
$ pwd \
$ cd SUPERCOMPUTING/ \
$ git pull \
$ bora 

*(in HPC at this point)*
$cd SUPERCOMPUTING/ \
$git pull 

___


### Task 2: downloading NCBI files via ftp
*(back on the local machine, used $exit )* 

$ ftp ftp.ncbi.nlm.nih.gov \
*(using "anonymous" as user and complete email address as password)*\
ftp> cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2

&emsp; *(checking that I'm in the right place:
&emsp; ftp> pwd
&emsp; "/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2" is the current directory )*

ftp> bye 
*(now in data directory)*

$ curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz 

$ curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz 

*(wget, get, curl all were not working in the actual ftp server environment, and when I looked it up and tried to use "passive" and "ls" I kept getting "Invalid Command", so I looked up how to do it outside the server.)*

$ tree 
___


### TASK 3
#### Task 3.1: trsanfer to HPC using Filezilla:
* opened FileZilla and used Quickconnect: 
	* Host: bora.sciclone.wm.edu
	* Port: 22
* navigated to the directory I downloaded the files to (on the left side)
* uploaded them
* showed that files successfully transferred

#### Task 3.2: making sure files are world-readable
*(back in git bash terminal)*
$ bora \
$cd SUPERCOMPUTING/assignments/assignment_02/data/ 

&emsp; *(checking the file permissions)* \
&emsp; $ls -l \
&emsp; *(outputs -rw------- for both files. means that only the owner can read and write; group and others have no permissions)* 

*(need to use chmod command to edit the file permissions- looked up which exact commands to use. "chmod 644" changes it so that group and others can also read)* \
$chmod 644 GCF_000005845.2_ASM584v2_genomic.fna.gz \
$chmod 644 GCF_000005845.2_ASM584v2_genomic.gff.gz 

&emsp; *(re-checking the file permissions)* \
&emsp; $ls -l \
&emsp; *(outputs -rw-r--r-- for both files. yay!)* 

---

### Task 4: Verifying file identity using md5sum
*(back into local machine in the ~/SUPERCOMPUTING/assignments/assignment_02/data directory, used $exit)*

$ md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz \
&emsp;*(output: **c13d459b5caa702ff7e1f26fe44b8ad7** \*GCF_000005845.2_ASM584v2_genomic.fna.gz)*

$ md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz \
&emsp;*(output: **0f52ffc94af5ddf544ff89cc6f546b0c** \*GCF_000005845.2_ASM584v2_genomic.gff.gz)*

$ bora \
*(now in HPC)*
$cd SUPERCOMPUTING/assignments/assignment_02/data/ \
$md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz \
&emsp;*(output: **c13d459b5caa702ff7e1f26fe44b8ad7**  GCF_000005845.2_ASM584v2_genomic.fna.gz)*

$md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz \
&emsp;*(output: **0f52ffc94af5ddf544ff89cc6f546b0c**  GCF_000005845.2_ASM584v2_genomic.gff.gz)*

the hashes (bolded long strings of characters) match up, whihc means that the files transferred correctly between the local machine and HPC

---

### Task 5: creating (editing) some useful bash aliases
*(bora, ll, u, and d aliases were created in class. ll, u, and d were simple but are modified slightly here)* 

*(on local machine, in the home directory)* \
$ nano .bashrc \
alias ll='ls -alFh --group-directories-first' \
alias u='cd ..;clear;pwd;ls -alFh --group-directories-first' \
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'

key:
* alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
	* cd ..: move UP one directory 
	* clear: clear whatever is on the terminal
	* pwd: print working directory (to know where we are)
	* ls: list
	* -a: all
	* -l: long format
	* -F: attaches a symbol for the specific type of file
	* -h: human readable
	* --group-directries-first: lists the directories first at the top of the list, and then individual files afterwards
* alias d='cd -;clear;pwd;ls -alFh --group-directories-first' * cd -: move DOWN one directory (previous 
	directory before the last cd command) * *(other components explained above)*
* alias ll='ls -alFh --group-directories-first
	* *(components all explained above)*

---
$ git status \
$ git add . \
$ git commit -m "downloaded NCBI files and confirmed they transferred successfully to HPC" \
$ git push origin main

*(pulling updated repository into HPC)* \
$ bora \
$git pull

---



### Reflection
The most frustrating part was working inside the ftp server to download the NCBI files. I was not able to get some commands ("wget," "get," "curl") 
to work inside the server, so once I establisehd that I could at least navigate in the server (with "cd," "pwd," and "bye"), I just downloaded them 
outside in the regular bash terminal (which I know we weren't supposed to do). I also kind of messed around with the version history and pulling and 
add/commit/push and I am 95% sure I lost my quiz_01.... I ended up deleting the local version of my SUPERCOMPUTING repository and when I cloned it 
again I realized that I must have never pushed the quizzes directory at all. The things that I were used to worked pretty well, including navigating 
in the repository, working in markdown, and secure-shellling into bora and exiting it.
