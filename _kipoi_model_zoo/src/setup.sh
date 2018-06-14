#!/bin/bash

main() {
    #set -ex
    sudo bash /etc/notebook/setup-git-lfs.sh
    sudo apt-get update
    sudo apt-get install -qqy tabix vcftools samtools bedtools
    
    cd /home/dnanexus

    dx download -r -f $DX_PROJECT_CONTEXT_ID:/notebooks/
    chown 1000:1000 -R /home/dnanexus/notebooks/
    
    export PATH=/anaconda3/bin/:$PATH
    unset  PYTHONPATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64/

    pip install docopt
    conda install -c conda-forge -y jupyter_contrib_nbextensions
    jupyter contrib nbextension install #whether we should use --user for this
    conda install -c conda-forge -y jupyter_nbextensions_configurator
    
    BRANCH=master
    git clone -b $BRANCH https://github.com/kipoi/kipoi.git
    pushd kipoi
    python setup.py install
    popd

    sudo chmod 755 /etc/notebook/start-notebook-2.sh
    sudo -u dnanexus -E /etc/notebook/start-notebook-2.sh

    echo 110 > /home/dnanexus/.timeout
    while true; 
      do 
        sleep 60; 
        remaining_time=$(cat /home/dnanexus/.timeout)
	echo remaining_time: $remaining_time
        if [[ $remaining_time -lt 0 ]]; then 
	   break;
	else 
	   echo $(($remaining_time - 1)) > /home/dnanexus/.timeout
	fi
      done;
    exit 0
}
