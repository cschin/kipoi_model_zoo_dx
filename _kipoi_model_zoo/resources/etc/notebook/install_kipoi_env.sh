#!/bin/bash

declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
declare -x PYTHONPATH="/usr/share/dnanexus/lib/python2.7/site-packages:/usr/share/dnanexus/lib/python2.7/site-packages:"
source /home/dnanexus/environment
echo $DX_PROJECT_CONTEXT_ID
dx select $(dx describe $DX_PROJECT_CONTEXT_ID --json | jq -r ".name")
#source ~/.dnanexus_config/unsetenv

GPU_INSTANCE=1
if [[ -z $(dx describe $DX_JOB_ID --json | jq ".instanceType" | grep "_gpu_" ) ]]; then
    GPU_INSTANCE=0
else
    GPU_INSTANCE=1
fi
echo $GPU_INSTANCE

model=$1
modelclean=${model//\//_}

export PATH=/anaconda3/bin/:$PATH
unset  PYTHONPATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/

if [[ $GPU_INSTANCE == 1 ]]; then
    kipoi env create $model --gpu --vep -e kipoi-${modelclean}
else
    kipoi env create $model --vep -e kipoi-${modelclean}
fi

source activate kipoi-${modelclean}

if [[ ! -z $(python --version |& grep "2.7") ]]; then
    conda remove pysam;
    pip install pysam==0.14
    if [[ $GPU_INSTANCE == 1 ]]; then
        pip install --upgrade tensorflow-gpu==1.8.0
        # pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.8.0-cp27-none-linux_x86_64.whl
    fi
fi

pip uninstall -y kipoi
BRANCH=master
git clone -b $BRANCH https://github.com/kipoi/kipoi.git
pushd /home/dnanexus/kipoi
python setup.py install
popd

chown 1000:1000 -R /home/dnanexus/.kipoi

pip install jupyter
pip install jupyterlab
python -m ipykernel install --name kipoi-${modelclean}

source deactivate kipoi-${modelclean}

