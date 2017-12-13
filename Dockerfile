FROM golang:1.9.2-alpine3.6
MAINTAINER marcelo correia <marcelo@correia.io>



RUN set -ex
RUN apk add --no-cache \
        bash \
        build-base \
        curl \
        git \
        jq \
        libffi-dev \
        make \
        openssh \
        openssl-dev \
        perl \
        py-pip \
        python-dev \
        tar \
        tzdata \
        unzip


WORKDIR /tmp

RUN apk add dos2unix --update-cache \
    --repository http://dl-3.alpinelinux.org/alpine/edge/community/ \
    --allow-untrusted

RUN pip install --upgrade pip
RUN pip install ansible awscli boto3

ADD json2yaml.py /usr/local/bin
ADD yaml2json.py /usr/local/bin

RUN mkdir -p /opt/workspace

RUN mkdir /tmp/discover
WORKDIR /tmp/discover
RUN GOPATH=$(pwd) go get -u github.com/hashicorp/go-discover/cmd/discover
RUN mv bin/discover /usr/local/bin

RUN mkdir /tmp/gox
WORKDIR /tmp/gox
RUN GOPATH=$(pwd) go get -u github.com/mitchellh/gox
RUN mv bin/gox /usr/local/bin

RUN curl https://github.com/aelsabbahy/goss/releases/download/v0.3.5/goss-linux-amd64 \
    -o /usr/local/bin/goss
RUN chmod 750 /usr/local/bin/goss

RUN curl https://glide.sh/get | sh

RUN rm -rf /tmp/discovery
RUN rm -rf /tmp/gox


WORKDIR /opt/workspace
