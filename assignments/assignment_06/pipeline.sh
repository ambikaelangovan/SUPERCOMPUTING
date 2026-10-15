#!/bin/bash
set -ueo pipefail

#downloading raw ONT data
bash scripts/01_download_data.sh

#setting up Flye
bash scripts/02_flye_2.9.6_manual_build.sh
bash scripts/02_flye_2.9.6_conda_install.sh


#running in each environemtn
bash scripts/03_run_flye_conda.sh
bash scripts/03_run_flye_module.sh
bash scripts/03_run_flye_local.sh


#comaprison
tail -n 10 ./assemblies/assembly_*/*_flye.log
