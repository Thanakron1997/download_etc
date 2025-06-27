#!/bin/bash
# git clone https://github.com/mattiamazzoli/workshop.git
# mov workshop workshop_mattia
set -e  # Exit on any error

# Set environment name
ENV_NAME="workshop"

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "Conda not found. Installing Miniconda..."

    # Download Miniconda installer
    MINICONDA_INSTALLER="Miniconda3-latest-MacOSX-arm64.sh"
    curl -O https://repo.anaconda.com/miniconda/$MINICONDA_INSTALLER

    # Install Miniconda silently
    bash $MINICONDA_INSTALLER -b -p $HOME/miniconda

    # Initialize conda
    eval "$($HOME/miniconda/bin/conda shell.bash hook)"
    conda init

    echo "Miniconda installed and initialized."
else
    echo "Conda is already installed."
    # Initialize conda in this shell
    eval "$(conda shell.bash hook)"
    conda update -n base -c defaults conda -y
fi

# Create environment if it doesn't exist
if conda info --envs | grep -q "^$ENV_NAME\s"; then
    echo "Conda environment '$ENV_NAME' already exists."
else
    echo "Creating environment '$ENV_NAME'..."
    conda create -y -n $ENV_NAME pandas jupyter matplotlib geopandas=1.1.0 scipy=1.15.2 arviz=0.21.0 pymc=5.53.0
    echo "Environment '$ENV_NAME' created with pandas and jupyter."
fi

echo "Done. To activate the environment, run:"
echo "  conda activate $ENV_NAME"

jupyter nbconvert --to notebook --execute workshop_mattia/InstallationTest.ipynb --output executed_test.ipynb

