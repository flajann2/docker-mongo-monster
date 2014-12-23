#!/bin/bash
# Run and link the shard cluster

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

function launch { # (name, image)
    name=$1
    image=$2
    other=$3
    docker run --name=$name -d --hostname=$name --link=pdns.srv:pdns.srv  --dns=$PDNS $other $image && register $name
}

###############################################################
# NOTE WELL
# Firstly, TokuMX requires that transparent hugepages disabled.
# for dockers, this must be done on the HOST system.
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled

# Secondly, the local Mongo must NOT be running, since the MongoS port will be
# exported here.
sudo killall -r mongod
###############################################################


# Start the all-important DNS server for this host's cluster.
# TODO: Use the Ambassador pattern to tie together a cluster across
# multiple boxen.
docker run --name=pdns.srv -d --hostname=pdns.srv pdns
getip pdns.srv
PDNS=$ip
sleep 30

# Register the name server with itself (later we'll use this)
register pdns.srv
echo "PDNS Server is on $PDNS"

# Config servers
launch cfg0.srv tokumx/toks-config
launch cfg1.srv tokumx/toks-config
launch cfg2.srv tokumx/toks-config

# Actual shards (should be repl clusters, but for now...)
launch shard0.srv  tokumx/toks-rep
launch shard1.srv  tokumx/toks-rep
launch shard2.srv  tokumx/toks-rep
launch shard3.srv  tokumx/toks-rep
launch shard4.srv  tokumx/toks-rep
launch shard5.srv  tokumx/toks-rep
launch shard6.srv  tokumx/toks-rep
launch shard7.srv  tokumx/toks-rep

launch shard8.srv  tokumx/toks-rep
launch shard9.srv  tokumx/toks-rep
launch shard10.srv tokumx/toks-rep
launch shard11.srv tokumx/toks-rep
launch shard12.srv tokumx/toks-rep
launch shard13.srv tokumx/toks-rep
launch shard14.srv tokumx/toks-rep
launch shard15.srv tokumx/toks-rep

echo "Waiting 60 seconds for everything to settle"
sleep 60

# MongoS gateway. Access point to the shards.
launch mongos.srv tokumx/toks-s --publish=27017:27017

#TODO: setup the shards via a mongo client
