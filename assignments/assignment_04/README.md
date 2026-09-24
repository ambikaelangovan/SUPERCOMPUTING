#README.md for Assignment_04, Ambika Elangovan, Sept 23 2026

## Task 1

**checked if "programs" directory was in my home:**
$cd /sciclone/home/aelangovan/
$ls
*(it was there!)*

---

## Task 2

**found the gh tarball file:**
- went to [https://github.com/cli/cli](https://github.com/cli/cli)
- scrolled through the README until "Installation", and clicked on the "releases page" for Linux & Unix
- scrolled through the release list until reached "GH CLI 2.74.2"
- clicked on the heading, took me to the GH CLI 2.74.2 page
- under assets, found "[GitHub CLI 2.74.2 linux amd64](https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz)"
- clicking that downloaded a tar.gz file


**downloading and unpacking the file in ~/programs:**
$wget [https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz](https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz)
$tar -xzvf gh_2.74.2_linux_amd64.tar.gz

*i think it worked, checking the contents:*
$ls gh_2.74.2_linux_amd64
*output:* bin  LICENSE  share

---
## Task 3

$nano install_gh.sh

*inside nano:*
#!/bin/bash
set -ueo pipefail
#1. download the tarball
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
#2. unpacking it
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
#3. remove donloaded tarball
rm gh_2.74.2_linux_amd64.tar.gz

*outside of nano at this point. checking the permissions*
$ls -l install_gh.sh
*output:* -rw-------. 1 aelangovan gzdata440 262 Sep 23 18:55 install_gh.sh
*(means i can read and write, but can't execute. need to change this!)*

$chmod +x install_gh.sh
*after rechecking permissions, output:* -rwx------. 1 aelangovan gzdata440 262 Sep 23 18:55 install_gh.sh

**removing the file that was manually downloaded in task 2 before writign the script:**
$rm -rf gh_2.74.2_linux_amd64

**running the script:**
$./install_gh.sh
$ls
*output:* datasets  gh_2.74.0_linux_amd64  gh_2.74.2_linux_amd64  greet.sh  install_datasets.sh  install_gh.sh

---
## Task 4

$echo $PATH
$ export PATH=$PATH:~/programs/gh_2.74.2_linux_amd64/bin

*(I didnt add it to the .bashrc because the "That's it. That's the task." feels like kind of a trick question...)*

---

## Task 5

$gh auth login
*going through the options, logged in with my authetication token*
*output confirmed I am logged in as ambikaelangovan*

---

## Task 6

*in ~/programs*
$git clone https://github.com/lh3/seqtk.git
$cd seqtk/
$make
$ls *output shows that seqtk is executable*

*back in ~/programs*
$nano install_seqtk.sh

*inside nano:*
#!/bin/bash
set -ueo pipefail
#1. cloning the repository
git clone https://github.com/lh3/seqtk
#2. going into the seqtk directory
cd seqtk
#3. seqtk has a Makefile file, so using make command
make
#4. adding directory to .bashrc
echo 'export PATH=$PATH:~/programs/seqtk' >> ~/.bashrc


$chmod +x install_seqtk.sh

$./install_seqtk.sh

$source ~/.bashrc

---
## Task 7:

*navigating back into assignment 3 folder to see if I hvae the file:*

$cd SUPERCOMPUTING/
$cd assignments/assignment_03/data
$ls *(output includes GCF_000001735.4_TAIR10.1_genomic.fna)*


---
## Task 8

$cd /SUPERCOMPUTING/assignments/assignment_04 

$nano summarize_fasta.sh


#!/bin/bash
set -ueo pipefail

##fasta file name is the first argument
fasta_file="$1"

##counting sequences
total_sequences=$(grep "^>" $fasta_file | wc -l)

##counting nucleotides
total_nucleotides=$(grep -v "^>" "$fasta_file" | tr -d '\n' | wc -c)

##creating table
##sequence titles
grep "^>" "$fasta_file" > sequences_titles.txt
##sequence lenghts
seqtk comp "$fasta_file" | cut -f2 > sequence_lengths.txt
##pasting them together
paste sequences_titles.txt sequence_lengths.txt > sequences_lengths.tsv

##reporting info with explanations
echo "FASTA file: $fasta_file"
echo "total number of sequences: $total_sequences"
echo "total number of nucleotides: $total_nucleotides"
echo "Sequence names and lengths:"
cat sequences_lengths.tsv


---

## Task 9

$mkdir data
$cd data
$cp ../../assignment_03/data/GCF_000001735.4_TAIR10.1_genomic.fna .

*(making copies)*
$cp GCF_000001735.4_TAIR10.1_genomic.fna GCF_000001735.4_TAIR10.1_genomic_copy2.fna
$cp GCF_000001735.4_TAIR10.1_genomic.fna GCF_000001735.4_TAIR10.1_genomic_copy3.fna

**for loop that runs over all the fasta files and outputs the summarize_fasta info**
$for fasta_file in data/*.fna
do
    ./summarize_fasta.sh "$fasta_file"
done
*(had to look up syntax for foor loop in bash language, seems pretty followable!!)*


---
## Task 10
I think this was one of the more tedious assignments for me, but I was able to do it smoothly by referencing my previous work pretty easily. It was pretty repetitive so it really helped enforce writing scripts I think. A new thing I learned was how to write for loops in bash!

From my understanding, $PATH is a variable that basically lists all the directories it "knows" to look into. Whenever we want to use a command/script, the bash shell will search inside the locations listed in $PATH for those commands.
