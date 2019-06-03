#!/bin/bash

# Set up conda environment with desired packages

# Detect Platform
if [ "$(uname -s)" == "Darwin" ]; then
    OS_PLATFORM="Mac"
elif [ "$(uname -s)" == "Linux" ]; then
    OS_PLATFORM="Linux"
else
    # Default to Linux
    OS_PLATFORM="Linux"
fi

while true; do
    read -p "Install Glotzer core packages? " yn
    case $yn in
        [Yy]* )
            GLOTZER_PKGS="hoomd freud signac signac-flow gsd fresnel"
            break
            ;;
        [Nn]* )
            GLOTZER_PKGS=""
            break
            ;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Install tensorflow/keras packages? " yn
    case $yn in
        [Yy]* )
            ML_PKGS="keras tensorflow"
            break
            ;;
        [Nn]* )
            ML_PKGS=""
            break
            ;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Install openmpi? " yn
    case $yn in
        [Yy]* )
            MPI_PKGS="openmpi"
            break
            ;;
        [Nn]* )
            MPI_PKGS=""
            break
            ;;
        * ) echo "Please answer yes or no.";;
    esac
done

SCIPY_PKGS="numpy pandas scipy matplotlib sympy seaborn statsmodels tqdm cython numba"
ML_PKGS="${ML_PKGS} scikit-learn networkx"
NB_PKGS="ipython ipykernel jupyterlab pythreejs"
DOC_PKGS="sphinx sphinx_rtd_theme nbsphinx"
DEV_PKGS="flake8 autopep8 nose ddt tbb tbb-devel coverage embree3 h5py ${MPI_PKGS}"
ALL_PKGS="$GLOTZER_PKGS $SCIPY_PKGS $ML_PKGS $NB_PKGS $DOC_PKGS $DEV_PKGS"

# Set up channels
conda config --add channels conda-forge

# Create environments if they don't exist
if [ -d $HOME/anaconda3/bin ]; then
    export CONDA_PATH="$HOME/anaconda3"
elif [ -d $HOME/miniconda3/bin ]; then
    export CONDA_PATH="$HOME/miniconda3"
fi

if [ ! -d "$CONDA_PATH/envs/glotzer" ]; then
    conda create --yes --name glotzer
fi

# Update/install packages
conda install --name glotzer $ALL_PKGS $CUSTOM_PKGS
