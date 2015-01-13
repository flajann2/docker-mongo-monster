#!/usr/bin/env bash
# Build the containers for sharding (need only be run once)

docker build -t pdns --rm=true pdns

# Tokumx
docker build -t tokumx/basic --rm=true tokumx
docker build -t tokumx/toks-s --rm=true toks-s
docker build -t tokumx/toks-config --rm=true toks-config
docker build -t tokumx/toks-rep --rm=true toks-rep

# Mongo 8
docker build -t mongo8/basic --rm=true mongo8
docker build -t mongo8/mon8-s --rm=true mon8-s
docker build -t mongo8/mon8-config --rm=true mon8-config
docker build -t mongo8/mon8-rep --rm=true mon8-rep
