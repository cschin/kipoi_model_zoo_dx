

Kipoi scoring variant DNAnexus App
==================================
see https://github.com/kipoi/kipoi/blob/master/docs/templates/using/02_Postprocessing.md


Docker
======

A Dockerfile is provided for running the applet within the DNAnexus kipoi_model_zoo project.

Build docker image
```
bash docker-build.sh
```

Run a test job, for example `test/test-Basset.sh` within the project:
```
docker run dx-kipoi-test $APITOKEN Basset
```
One needs to replace `$APITOKEN` with proper [API token](https://wiki.dnanexus.com/Command-Line-Client/Login-and-Logout#Authentication-Tokens).

