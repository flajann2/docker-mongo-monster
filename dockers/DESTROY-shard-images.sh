#!/usr/bin/env bash
# DESTROY the containers for sharding (need only be run once)

docker rmi -f mongo/shard-s
docker rmi -f mongo/shard-config
docker rmi -f mongo/shard-rep
docker rmi -f mongo/basic
