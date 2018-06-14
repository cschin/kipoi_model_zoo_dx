#!/bin/bash
pushd /tmp
wget -q https://repo.continuum.io/archive/Anaconda2-5.1.0-Linux-x86_64.sh
bash Anaconda2-5.1.0-Linux-x86_64.sh -b -p /anaconda2

unset PYTHONPATH
export PATH=/anaconda2/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/

pip install --upgrade tensorflow-gpu==1.8.0
/anaconda2/bin/python -m ipykernel install  --name "python2.7"
popd
