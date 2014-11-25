# MongoDB Shard MongoS Gateway server
# There can be more than one of these, but all must use the exact same --configdb configuration.

FROM mongo/basic:latest
MAINTAINER Fred Mitchell

COPY etc/ /etc/
EXPOSE 27017
ENTRYPOINT ["/usr/bin/mongos"]
CMD ["--chunkSize", "16", "--port", "27017", "--configdb", "cfg0.srv:27019,cfg1.srv:27019,cfg2.srv:27019"]
