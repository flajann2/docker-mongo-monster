# TokuMX Shard MongoS Gateway server
# There can be more than one of these, but all must use the exact same --configdb configuration.

FROM tokumx/basic:latest
MAINTAINER Fred Mitchell

COPY etc/ /etc/
EXPOSE 27017
ENTRYPOINT ["/tokumx/bin/mongos"]
CMD ["--config", "/etc/tokumx.conf"]
