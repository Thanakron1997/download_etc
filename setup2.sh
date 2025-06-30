#!/bin/bash

set -e  # Exit on any error
# remove old env
conda remove -y -n workshop_mattia --all
conda create -y -c conda-forge -n workshop_mattia python=3.12.11 pandas jupyter matplotlib geopandas=1.1.0 scipy=1.15.2 arviz=0.21.0 pymc=5.23.0
conda init
conda activate workshop_mattia
conda list
