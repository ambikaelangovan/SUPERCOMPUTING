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
