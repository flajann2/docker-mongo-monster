#!/bin/sh 
docker rm $(docker ps -a -q)
docker rmi -f $(docker images -q)
