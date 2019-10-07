FROM ubuntu:18.04

# Setting up repos
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl software-properties-common wget git
RUN curl -sL https://deb.nodesource.com/setup_12.x | sh -
RUN add-apt-repository ppa:deadsnakes/ppa

# Installing and building tdlib.
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y make zlib1g-dev libssl-dev gperf php cmake gcc g++ git python3.7-dev nodejs \
    clang-6.0 libc++abi-dev libc++-dev

RUN git clone https://github.com/tdlib/td.git
RUN mkdir td/build
WORKDIR td/build
ENV CXXFLAGS="-stdlib=libc++"
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DCMAKE_AR=/usr/bin/llvm-ar-6.0 -DCMAKE_NM=/usr/bin/llvm-nm-6.0 \
    -DCMAKE_OBJDUMP=/usr/bin/llvm-objdump-6.0 -DCMAKE_RANLIB=/usr/bin/llvm-ranlib-6.0 ..
RUN cd .. && php SplitSource.php
RUN cmake --build . --target install
WORKDIR ../..

# Installing golang.
RUN wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz
RUN mkdir /golang
ENV GOPATH=/golang
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
