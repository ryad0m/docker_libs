FROM ubuntu:18.04

# Setting up repos
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime
RUN apt-get update && apt-get upgrade -y && apt-get install -y software-properties-common wget git
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y make zlib1g-dev libssl-dev gperf php cmake gcc g++ git python3.7-dev pkg-config

# Setting up python pkg-config.
RUN ln -s /usr/lib/x86_64-linux-gnu/pkgconfig/python-3.7.pc /usr/lib/x86_64-linux-gnu/pkgconfig/python3.pc

# Building and installing tdlib.
RUN git clone https://github.com/tdlib/td.git
RUN mkdir td/build
WORKDIR td/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
RUN cmake --build . --target prepare_cross_compiling
RUN cd .. && php SplitSource.php
RUN cmake --build . --target install
WORKDIR ../..

# Installing golang.
RUN wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz
RUN mkdir /golang
ENV GOPATH=/golang
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
