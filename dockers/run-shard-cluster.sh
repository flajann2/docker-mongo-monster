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
    docker run --name=$name -d --hostname=$name --dns=$PDNS $other $image && register $name
}


# Start the all-important DNS server for this host's cluster.
# TODO: Use the Ambassador pattern to tie together a cluster across
# multiple boxen.
docker run --name=pdns.srv -d --hostname=pdns.srv pdns
getip pdns.srv
PDNS=$ip
register pdns.srv
echo "PDNS Server is on $PDNS"
sleep 10

# Config servers
launch cfg0.srv mongo/shard-config
launch cfg1.srv mongo/shard-config
launch cfg2.srv mongo/shard-config

# Actual shards (should be repl clusters, but for now...)
launch shard0.srv mongo/shard-rep
launch shard1.srv mongo/shard-rep
launch shard2.srv mongo/shard-rep
launch shard3.srv mongo/shard-rep
launch shard4.srv mongo/shard-rep
launch shard5.srv mongo/shard-rep
launch shard6.srv mongo/shard-rep
launch shard7.srv mongo/shard-rep

echo "Waiting 60 seconds for everything to settle"
sleep 30

# MongoS gateway. Access point to the shards.
launch mongos.srv mongo/shard-s --publish=27017:27017

#TODO: setup the shards via a mongo client
