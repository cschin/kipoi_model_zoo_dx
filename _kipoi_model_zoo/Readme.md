A experimental applet that setups Kipoi (http://kipoi.org/) environment and
automatically generating a Jupyter notebook to run Kipoi model with Python.

base versions of drviers/tools installed

- nvidia driver 384.81
- cuda 9.0
- cudnn-7.0
- Anaconda3-5.1.0 (in /anaconda3/)
- tensorflow_gpu-1.8.0

This applet is current designed to be launched by a bash script from command line on Mac (or Linux without
automatically starting brower tab for the jupyter notebook.)

To launch, using `dx` to select the `kipoi_model_zoo` project and download the launch bash script with
`dx download dx_run_kipoi.sh`.

The `dx_run_kipoi.sh` takes two positional argument as `bash dx_run_kipoi.sh kipoi_model instance_type`.
For example, `bash dx_run_kipoi.sh Basset mem3_ssd1_x8` will create an environment defined by Kipoi
"Basset" model on a `mem3_ssd1_x8` instance.  It will automatically process SSH tunnelling for launching
Jupyter notebook on Mac OS X. You can ignore the instance type and it is default to `mem3_ssd1_x8`.


