FROM buildpack-deps:jessie-curl

MAINTAINER Nathan Herald <nathan.herald@microsoft.com>

ARG sha
ARG start

ENV CONSUL_SHA256 171cf4074bfca3b1e46112105738985783f19c47f4408377241b868affa9d445
ENV CONSUL_VERSION 0.5.2
ENV DNS_RESOLVES consul
ENV DNS_PORT 8600

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

RUN apt-get update \
 && mkdir /opt/app \
 && mkdir /opt/src

RUN apt-get install unzip

RUN curl -o /opt/src/consul.zip https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip \
 && echo "${CONSUL_SHA256}  /opt/src/consul.zip" > /opt/src/consul.sha256 \
 && sha256sum -c /opt/src/consul.sha256 \
 && cd /opt/app \
 && unzip /opt/src/consul.zip \
 && chmod +x /opt/app/consul \
 && rm /opt/src/consul.zip

ADD . /opt/app/

RUN echo $start > /opt/start \
 && chmod +x /opt/start

RUN echo $sha > /opt/app/sha

CMD /opt/start

