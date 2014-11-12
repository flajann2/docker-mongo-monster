# MongoDB Shard Configuration server:
# Exactly 3 of these instances needs to be created.

FROM mongo/basic:latest
MAINTAINER Fred Mitchell

RUN mkdir -p /data/configdb

COPY etc/ /etc/
EXPOSE 27019
ENTRYPOINT ["/usr/bin/mongod"]
CMD ["--port", "27019", "--dbpath", "/data/configdb", "--configsvr"]
