# Dockerizing MongoDB8: Dockerfile for building MongoDB images

FROM       centos:centos6
MAINTAINER Fred Mitchell

RUN yum install tar -y

RUN mkdir -p /data/mongodb
RUN mkdir -p /mongodb/

COPY etc/ /etc/
COPY mongo8-tar/ /mongodb/

RUN cd /mongodb && tar xzf mongodb-linux-x86_64-2.8.0-rc4.tgz && mv mongodb-linux-x86_64-2.8.0-rc4/* .
RUN cd /mongodb && rm -rf mongodb-linux-x86_64-2.8.0-rc4 mongodb-linux-x86_64-2.8.0-rc4.tgz

EXPOSE 27017
ENTRYPOINT ["/mongodb/bin/mongod"]
CMD ["--port", "27017", "--config", "/etc/mongodb.conf"]
