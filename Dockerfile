FROM ghdl/ghdl:ubuntu18-llvm-5.0

MAINTAINER Vinícius Dantas <vinicius.gppcom@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \ 
    apt-get -y upgrade && \
    apt-get -y install cmake make
