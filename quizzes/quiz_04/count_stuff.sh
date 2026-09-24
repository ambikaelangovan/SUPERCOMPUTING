#!/bin/bash
set -ueo pipefail

#directory as positional argument
directory="$1"

#number of files and directories
ls -al | wc -l > num_files.txt

cat num_files.txt

