docker build -t dx-kipoi-test dx-tk-docker/
docker tag dx-kipoi-test:latest cschin/dx-kipoi-test:latest
docker push cschin/dx-kipoi-test:latest
