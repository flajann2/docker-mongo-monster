#!/bin/bash
# Run and link the shard cluster

# NOTE WELL: mongos will attach to the host's 27017 mongo port, so
# the host mongodb must not be running on that port!!!!!

# Config servers
docker run --name=cfg0.srv -d --hostname=cfg0.srv mongo/shard-config
docker run --name=cfg1.srv -d --hostname=cfg1.srv mongo/shard-config
docker run --name=cfg2.srv -d --hostname=cfg2.srv mongo/shard-config

# Actual shards (should be repl clusters, but for now...)
docker run --name=shard0.srv  -d --hostname=shard0.srv mongo/shard-rep
docker run --name=shard1.srv  -d --hostname=shard1.srv mongo/shard-rep
docker run --name=shard2.srv  -d --hostname=shard2.srv mongo/shard-rep
docker run --name=shard3.srv  -d --hostname=shard3.srv mongo/shard-rep
docker run --name=shard4.srv  -d --hostname=shard4.srv mongo/shard-rep
docker run --name=shard5.srv  -d --hostname=shard5.srv mongo/shard-rep
docker run --name=shard6.srv  -d --hostname=shard6.srv mongo/shard-rep
docker run --name=shard7.srv  -d --hostname=shard7.srv mongo/shard-rep

echo "Waiting 60 seconds for everything to settle"
sleep 60

# MongoS gateway. Access point to the shards.
# We can have more than one of these, and we definitely should
# in production. We use Docker's linking for the DNS resolution, we'll
# need a better approach later so we can add shards on the fly if need be.
docker run --name=mongos.srv -p 27017:27017 -d --hostname=mongos.srv \
    --link=cfg0.srv:cfg0.srv --link=cfg1.srv:cfg1.srv --link=cfg2.srv:cfg2.srv \
    --link=shard0.srv:sh0 \
    --link=shard1.srv:sh1 \
    --link=shard2.srv:sh2 \
    --link=shard3.srv:sh3 \
    --link=shard4.srv:sh4 \
    --link=shard5.srv:sh5 \
    --link=shard6.srv:sh6 \
    --link=shard7.srv:sh7 \
    mongo/shard-s
