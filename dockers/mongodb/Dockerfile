# Dockerizing MongoDB: Dockerfile for building MongoDB images

FROM       ubuntu:14.04
MAINTAINER Fred Mitchell

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

RUN apt-get update && apt-get install -y mongodb-org

RUN mkdir -p /data/mongodb
COPY etc/ /etc/
EXPOSE 27017
ENTRYPOINT ["/usr/bin/mongod"]
CMD ["--port", "27017", "--dbpath", "/data/mongodb"]
