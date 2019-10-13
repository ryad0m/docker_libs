FROM alpine:3.10.2

RUN apk add --no-cache --update ca-certificates gperf alpine-sdk openssl-dev git \
    cmake zlib-dev linux-headers php php-ctype \
    nodejs nodejs-npm musl-dev go python python-dev py-pip build-base alpine-sdk

ENV GOPATH=/opt/go/ 
ENV PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"

WORKDIR /tmp/_build_tdlib/
RUN git clone https://github.com/tdlib/td.git /tmp/_build_tdlib/ --branch v1.5.0

RUN mkdir build
WORKDIR /tmp/_build_tdlib/build/

RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
RUN cmake --build . --target install
