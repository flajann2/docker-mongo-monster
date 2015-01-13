#!/usr/bin/env bash
# DESTROY the containers for sharding (need only be run once)

docker rm $(docker ps -a -q)

docker rmi -f tokumx/toks-s
docker rmi -f tokumx/toks-config
docker rmi -f tokumx/toks-rep
docker rmi -f tokumx/basic

docker rmi -f mongo8/basic
docker rmi -f mongo8/mon8-s
docker rmi -f mongo8/mon8-config
docker rmi -f mongo8/mon8-rep
