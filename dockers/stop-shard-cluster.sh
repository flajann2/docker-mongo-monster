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
