#!/bin/bash

unset PYTHONPATH
export PATH=/anaconda3/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/
conda install -c conda-forge git-lfs && git lfs install
