#!/bin/sh
# Install Jupyterextension package
conda install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user

# Install configurator and enable configurator
conda install jupyter_nbextensions_configurator
jupyter nbextensions_configurator enable
