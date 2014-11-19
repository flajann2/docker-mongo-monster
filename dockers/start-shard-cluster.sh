#!/bin/bash
# Start up the Shard cluster

# NOTE WELL: mongos will attach to the host's 27017 mongo port, so
# the host mongodb must not be running on that port!!!!!

# Shut down host's mongodb, if there
sudo service mongodb stop

# Name server
docker start pdns.srv

sleep 10

# Config servers
docker start cfg0.srv
docker start cfg1.srv
docker start cfg2.srv

# Actual shards (should be repl clusters, but for now...)
docker start shard0.srv
docker start shard1.srv
docker start shard2.srv
docker start shard3.srv
docker start shard4.srv
docker start shard5.srv
docker start shard6.srv
docker start shard7.srv

docker start shard8.srv
docker start shard9.srv
docker start shard10.srv
docker start shard11.srv
docker start shard12.srv
docker start shard13.srv
docker start shard14.srv
docker start shard15.srv

echo "Waiting 60 seconds for everything to settle"
sleep 60

docker start mongos.srv
