#!/bin/bash
set -ueo pipefail

#initializing
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

#building conda (mambda) enironment
mamba create -y -n flye-env -c conda-forge -c bioconda flye=2.9.6

#activating
conda activate flye-env
#testing
flye -v
#documenting environment
conda env export --no-builds > ./flye-env.yml

#deactivating
conda deactivate
