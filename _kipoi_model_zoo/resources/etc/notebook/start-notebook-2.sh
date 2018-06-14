#!/bin/bash

unset PYTHONPATH
export PATH=/anaconda3/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/
# source activate kipoi
mkdir -p $HOME/notebooks/
cd $HOME/notebooks/
# /etc/notebook/generate_kipoi_notebook.py $model ${model}.ipynb
jupyter notebook --no-browser  --NotebookApp.token=''  --NotebookApp.disable_check_xsrf=True &
