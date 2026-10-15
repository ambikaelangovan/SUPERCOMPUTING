#!/bin/bash
set -ueo pipefail

cd ~/programs
rm -rf ~/programs/Flye

# copied from Flye INSTALL.md
git clone https://github.com/fenderglass/Flye
cd Flye
make THREADS=1

#checking!!!!
~/programs/Flye/bin/flye --version
