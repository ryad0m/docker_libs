FROM alpine:3.10.2

RUN apk add --no-cache ca-certificates gperf alpine-sdk openssl-dev git cmake zlib-dev \
    nodejs nodejs-npm musl-dev go python python-dev py-pip build-base 

WORKDIR /tmp/_build_tdlib/

RUN git clone https://github.com/tdlib/td.git /tmp/_build_tdlib/ --branch v1.5.0

RUN mkdir build
WORKDIR /tmp/_build_tdlib/build/

RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build .
RUN make install


nodejs nodejs-npm
