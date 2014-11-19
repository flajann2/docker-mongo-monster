#!/bin/bash
# Shut down the Shard cluster

docker stop mongos.srv

# Config servers
docker stop cfg0.srv
docker stop cfg1.srv
docker stop cfg2.srv

# Actual shards 
docker stop shard0.srv
docker stop shard1.srv
docker stop shard2.srv
docker stop shard3.srv
docker stop shard4.srv
docker stop shard5.srv
docker stop shard6.srv
docker stop shard7.srv

docker stop shard8.srv
docker stop shard9.srv
docker stop shard10.srv
docker stop shard11.srv
docker stop shard12.srv
docker stop shard13.srv
docker stop shard14.srv
docker stop shard15.srv

# And finally, take out the name server
# docker stop pdns.srv

echo "Leave pdns.srv running for now, since we'll loose its"
echo "IP address otherwise. This will"
