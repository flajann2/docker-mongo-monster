#!/usr/bin/env bash
# Build the containers for sharding (need only be run once)

docker build -t mongo/basic --rm=true mongodb
docker build -t mongo/shard-s --rm=true shard-s
docker build -t mongo/shard-config --rm=true shard-config
docker build -t mongo/shard-rep --rm=true shard-rep
