#!/bin/bash

if [ -n "$1" ];
then 
	echo set instance type to $1
	INSTANCE_TYPE=$1
else
	echo no instance type set, using mem3_ssd1_x8, for GPU set the instance to mem3_ssd1_gpu_x8
	INSTANCE_TYPE=mem1_ssd1_x4
fi

JOBID=$(dx run _kipoi_model_zoo -i model=$MODEL --allow-ssh -y --brief --instance-type $INSTANCE_TYPE)
i=0
while true; do
    (dx watch  --get-stderr --no-wait --no-job-info $JOBID 2> /dev/null | grep "Jupyter Notebook is running") && break
    state=$(dx describe $JOBID | grep State | tr -s ' ' | cut -d' ' -f 2 )
    echo "Waiting for the worker ($JOBID) to start up, unpacking asset and running Jupyter/$i,  $state"
    i=$((i+1))
    sleep 20
done
echo "Jupyter Notebook is running"
dx ssh --suppress-running-check $JOBID -o "StrictHostKeyChecking no" -f -L 2001:localhost:8888 -N
echo "The dx_run_kipoi.sh will execute 'open http://localhost:2001/' now"
echo "If you are not on a Mac OS X, please just point your browser to http://localhost:2001/"
echo "If the port 2001 is already been used, you might have to change to ssh tunnelling port manually for now"
open http://localhost:2001/lab
