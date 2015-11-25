FROM buildpack-deps:jessie-curl

MAINTAINER Nathan Herald <nathan.herald@microsoft.com>

ENV CONSUL_VERSION 0.5.2
ENV CONSUL_DOWNLOAD_URL https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip
ENV CONSUL_SHA256 171cf4074bfca3b1e46112105738985783f19c47f4408377241b868affa9d445

ENV CONSUL_JOIN_VERSION 0.0.1
ENV CONSUL_JOIN_DOWNLOAD_URL https://github.com/wakeful-deployment/consul-join/releases/download/v${CONSUL_JOIN_VERSION}/consul-join-x86-linux.zip
ENV CONSUL_JOIN_SHA256 0446b5ed3dc61c2981c49f86ae1e254ac19315f781a9d1e7a3ef91b7eae8d56c

ENV BOOTSTRAP_EXPECT 3
ENV DNS_RESOLVES consul
ENV DNS_PORT 8600

ENV PATH /opt/app/bin:$PATH

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

RUN apt-get update \
 && mkdir /opt/app \
 && mkdir /opt/app/bin \
 && mkdir /opt/src

RUN apt-get install unzip

RUN curl -o /opt/src/consul.zip "${CONSUL_DOWNLOAD_URL}" \
 && echo "${CONSUL_SHA256}  /opt/src/consul.zip" > /opt/src/consul.sha256 \
 && sha256sum -c /opt/src/consul.sha256 \
 && cd /opt/app/bin \
 && unzip /opt/src/consul.zip \
 && chmod +x /opt/app/bin/consul \
 && rm /opt/src/consul.zip

RUN curl -o /opt/src/consul-join.zip -L "${CONSUL_JOIN_DOWNLOAD_URL}" \
 && echo "${CONSUL_JOIN_SHA256}  /opt/src/consul-join.zip" > /opt/src/consul-join.sha256 \
 && sha256sum -c /opt/src/consul-join.sha256 \
 && cd /opt/app/bin \
 && unzip /opt/src/consul-join.zip \
 && chmod +x /opt/app/bin/consul-join \
 && rm /opt/src/consul-join.zip

ADD . /opt/src/

RUN mv /opt/src/config /opt/app/config

ARG sha
ARG start

RUN echo $start > /opt/start \
 && chmod +x /opt/start

RUN echo $sha > /opt/app/sha

CMD /opt/start

