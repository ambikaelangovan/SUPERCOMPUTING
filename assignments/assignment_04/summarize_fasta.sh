#!/bin/bash
set -ueo pipefail

#fasta file name is the first argument
fasta_file="$1"


#counting sequences
total_sequences=$(grep "^>" $fasta_file | wc -l)


#counting nucleotides
total_nucleotides=$(grep -v "^>" "$fasta_file" | tr -d '\n' | wc -c)


#creating table
##sequence titles
grep "^>" "$fasta_file" > sequences_titles.txt
##sequence lenghts
seqtk comp "$fasta_file" | cut -f2 > sequence_lengths.txt
##pasting them together
paste sequences_titles.txt sequence_lengths.txt > sequences_lengths.tsv


#reporting info with explanations
echo "FASTA file: $fasta_file"
echo "total number of sequences: $total_sequences"
echo "total number of nucleotides: $total_nucleotides"
echo "Sequence names and lengths:"
cat sequences_lengths.tsv
