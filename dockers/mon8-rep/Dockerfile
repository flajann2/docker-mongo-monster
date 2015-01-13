# TokuMX Shard 
# This should really be a Replication Set

FROM tokumx/basic:latest
MAINTAINER Fred Mitchell

RUN mkdir -p /data/tokumx

COPY etc/ /etc/
EXPOSE 27017
ENTRYPOINT ["/tokumx/bin/mongod"]
CMD ["--config", "/etc/tokumx.conf"]
