#!/usr/bin/env bash
# Build the containers for sharding (need only be run once)

docker build -t pdns --rm=true pdns
docker build -t tokumx/basic --rm=true tokumx
docker build -t tokumx/toks-s --rm=true toks-s
docker build -t tokumx/toks-config --rm=true toks-config
docker build -t tokumx/toks-rep --rm=true toks-rep
