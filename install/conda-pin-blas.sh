#!/bin/bash

# This pins conda to use the openblas packages from conda-forge
# See https://conda-forge.readthedocs.io/en/latest/blas.html

echo "blas=*=openblas" > $CONDA_PREFIX/conda-meta/pinned
