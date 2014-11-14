docker-mongo-monster
====================

Allow docker to spin up sharded Mongo cluster

## Dockers

A number of docekrs were created to make this project work.

### shard-s

mongos server, gateway to the shards

### shard-config

Config servers for the shard cluster. There must be exactly 3 functioning or the
shard goes into read-only mode with regards to chunk splitting.

### shard-rep

Actual MongoDB shards, which (should be) replica sets.

### pdns

Nameserver for the monster dockert infrastructure. Based on PowerDNS and Sqlite3.

## The (near) Future

The pdns docker will serve as the basis for the namespace across distributed docker nodes
across different host servers. For now, all is geared to run in one host server. In the
future, this will all change of course. Use the Ambassador pattern so that dockers on
the different host servers can all talk to the (master) pdns docker. Actually,
the pdns dockers as name servers should be seperate replicas with the ambassadors being
able to connect to whatever is available so that there is no single point of failure.

A number of convience scripts have been created in the dockers directory for the
initial deployment of the images and containers. Eventually they should all
be converted to Chef scripts to allow for ease of maintenance of the infrastructure.

## General Notes

Ruby sinatra has been used as a simple REST interface to allow dockers to insert its discovery
information into pdns. Later, this will be expanded to allow for updates across disparate
servers (or a more convential approach may be employed at that point)
