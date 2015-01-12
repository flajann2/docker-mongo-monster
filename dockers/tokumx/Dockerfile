# Dockerizing TokuMX: Dockerfile for building TokuMX images

FROM       centos:centos6
MAINTAINER Fred Mitchell

RUN yum install tar -y

RUN mkdir -p /data/tokumx
RUN mkdir -p /tokumx/

COPY etc/ /etc/
COPY tokumx-tar/ /tokumx/

RUN cd /tokumx && tar xzf tokumx-2.0.0-linux-x86_64-main.tar.gz && mv tokumx-2.0.0-linux-x86_64/* .
RUN cd /tokumx && rm -rf tokumx-2.0.0-linux-x86_64 tokumx-2.0.0-linux-x86_64-main.tar.gz

EXPOSE 27017
ENTRYPOINT ["/tokumx/bin/mongod"]
CMD ["--port", "27017", "--config", "/etc/tokumx.conf"]
