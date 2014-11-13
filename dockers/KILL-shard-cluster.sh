#!/bin/bash
# REMOVE CLUSTER
# DANGER DANNGER DANGER

docker rm -f mongos.srv
docker rm -f  cfg0.srv
docker rm -f  cfg1.srv
docker rm -f  cfg2.srv
docker rm -f  shard0.srv
docker rm -f  shard1.srv
docker rm -f  shard2.srv
docker rm -f  shard3.srv
docker rm -f  shard4.srv
docker rm -f  shard5.srv
docker rm -f  shard6.srv
docker rm -f  shard7.srv
