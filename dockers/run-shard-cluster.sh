#!/bin/bash
# Run and link the shard cluster
# parameters:
# run-shard-cluster.sh CLUSTER-NAME NUM-SHARD-SERVERS NUM-SHARD-PER-SERVER

# Parameters
CLUSTER=$1
SVS=$2
SH_PER_SV=$3

# 
REPO="docker-repo:2061"
SHARD_PORT=28000

# NOTE WELL: mongos will attach to the host's 27017 mongo port, so
# the host mongodb must not be running on that port!!!!!

function getip {
    ip=$(docker inspect -f "{{.NetworkSettings.IPAddress}}" $1)
}

# parameter is the name of the running container
function register {
    getip $1
    curl -H "Content-type: application/json" -X POST http://$PDNS:2001/name/$1/ip/$ip
}

function launch_docker { # (name, image)
    name=$1
    image=$2
    other=$3
    #docker run --name=$name -d --hostname=$name --link=pdns.srv:pdns.srv  --dns=$PDNS $other $image && register $name
}

# Launch a Google Server Instance
function launch_sv { # name
    name=$1
    
}

function launch_cfg { # (name, image)
    name=$1
    image=$2
    other=$3
    echo "launch_cfg($name, $image)"
    #docker run --name=$name -d --hostname=$name --link=pdns.srv:pdns.srv  --dns=$PDNS $other $image && register $name
}

function launch_shs { # (name, image)
    name=$1
    image=$2
    other=$3
    echo "launch_shs($name, $image)"
    #docker run --name=$name -d --hostname=$name --link=pdns.srv:pdns.srv  --dns=$PDNS $other $image && register $name
}

echo "Creating and running for cluster $CLUSTER: shards servers: $SVS, shards per server: $SH_PER_SV"

###############################################################
# NOTE WELL
# Firstly, TokuMX requires that transparent hugepages disabled.
# for dockers, this must be done on the HOST system.
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled

# Start the all-important DNS server for this host's cluster.
# TODO: Use the Ambassador pattern to tie together a cluster across
# multiple boxen.
#docker run --name=pdns.srv -d --hostname=pdns.srv pdns
#getip pdns.srv
#PDNS=$ip
#sleep 30

# Register the name server with itself (later we'll use this)
#register pdns.srv
#echo "PDNS Server is on $PDNS"

# Config servers
for i in $(seq 0 2); do
    launch_cfg ${CLUSTER}-cfg$i tokumx/toks-config
done


# Actual shards (should be repl clusters, but for now...)
for i in $(seq 0 $(($SVS - 1)) ); do
    launch_shs ${CLUSTER}-shs$i tokumx/toks-rep
done

# MongoS gateway. Access point to the shards.
#launch mongos.srv tokumx/toks-s --publish=27017:27017

#TODO: setup the shards via a mongo client
