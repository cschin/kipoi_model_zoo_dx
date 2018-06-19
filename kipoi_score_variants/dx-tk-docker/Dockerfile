FROM ubuntu:16.04
WORKDIR /dx-toolkit
RUN apt-get update
RUN apt-get install -qqy wget
RUN wget https://wiki.dnanexus.com/images/files/dx-toolkit-v0.255.0-ubuntu-14.04-amd64.tar.gz
RUN apt-get install -qqy python2.7
RUN tar zxvf dx-toolkit-v0.255.0-ubuntu-14.04-amd64.tar.gz
RUN rm dx-toolkit-v0.255.0-ubuntu-14.04-amd64.tar.gz
RUN apt-get install -qqy git
RUN git clone https://github.com/cschin/kipoi_model_zoo_dx
ADD entry.sh /dx-toolkit
ENTRYPOINT ["/dx-toolkit/entry.sh"]
