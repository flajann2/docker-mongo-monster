# MongoDB Shard 
# This should really be a Replication Set

FROM mongo/basic:latest
MAINTAINER Fred Mitchell

RUN mkdir -p /data/mongodb

COPY etc/ /etc/
EXPOSE 27017
ENTRYPOINT ["/usr/bin/mongod"]
CMD ["--port", "27017", "--dbpath", "/data/mongodb"]
