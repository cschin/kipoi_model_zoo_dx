#!/bin/bash

main() {
    set -ex
    dx-download-all-inputs
    sudo bash /etc/dx-app/setup-git-lfs.sh
    sudo apt-get update
    sudo apt-get install -qqy tabix vcftools samtools
    GPU_INSTANCE=0
    if [[ -z $(dx describe $DX_JOB_ID --json | jq ".instanceType" | grep "_gpu_" ) ]]; then
       GPU_INSTANCE=0
    else
       GPU_INSTANCE=1
    fi
    O_PYTHONPATH=$PYTHONPATH
    O_PATH=$PATH
    unset PYTHONPATH
    export PATH=/anaconda3/bin/:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64/
    conda update -n base conda -y
    pip install kipoi

    # quick hack for using a particular repo/branch
    # BRANCH=unicode_fix
    # git clone -b $BRANCH https://github.com/cschin/kipoi.git
    # pushd kipoi
    # python setup.py install
    # popd 

    pip install docopt

    if [[ $GPU_INSTANCE == 0 ]]; then
       kipoi env create $model --vep -e kipoi-var-effect
    else
       kipoi env create $model --gpu --vep -e kipoi-var-effect
    fi

    source activate kipoi-var-effect

    # quick hack for using a particular repo/branch
    # pushd kipoi
    # python setup.py install  # test github version, overide the version installed by `kipoi env create`
    # popd 

    chown 1000:1000 -R /home/dnanexus/.kipoi

    if [[ ! -z $(python --version |& grep "2.7") ]]; then 
        conda remove pysam; 
        pip install pysam==0.14
    fi

    gzip -dc ${fasta_file_path} > ref.fa
    samtools faidx ref.fa
    tabix -p vcf ${vcf_file_path}

    if [ ! -z "${gtf_file}" ]; then
      dataloader_args='{"gtf_file":"'${gtf_file_path}'","fasta_file":"ref.fa"}'
    else
      dataloader_args='{"fasta_file":"ref.fa","use_linecache":true}'
    fi
    echo "dataloader_args=" ${dataloader_args}

    kipoi postproc score_variants ${model} --dataloader_args=${dataloader_args}\
	                                   --num_workers=${num_workers} \
					   --batch_size=${batch_size} \
	                                   -i ${vcf_file_path}\
					   -o /home/dnanexus/${output_prefix}_pscore.vcf -e ${output_prefix}_pscore.tsv > run_log 

    bgzip /home/dnanexus/${output_prefix}_pscore.vcf

    mkdir -p $HOME/out/output_vcf_file
    mv ${output_prefix}_pscore.vcf.gz $HOME/out/output_vcf_file
    # mv ${output_prefix}_pscore.tsv $HOME/out/output_vcf_file

    source deactivate
    export PYTHONPATH=${O_PYTHONPATH}
    export PATH=${O_PATH}

    dx-upload-all-outputs
}
