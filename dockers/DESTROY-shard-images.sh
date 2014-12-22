#!/usr/bin/env bash
# DESTROY the containers for sharding (need only be run once)

docker rmi -f tokumx/toks-s
docker rmi -f tokumx/toks-config
docker rmi -f tokumx/toks-rep
docker rmi -f tokumx/basic
