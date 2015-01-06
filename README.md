# docker-mongo-monster

Allow docker to spin up sharded TokuMX cluster

## Preminary

Basically, this effort can create a shard cluster across multiple servers
using the Google Cloud command-line API. The approriate scripts... TBD

## Dockers

A number of docekrs were created to make this project work.

### toks-s

mongos server, gateway to the shards

### toks-config

Config servers for the shard cluster. There must be exactly 3 functioning or the
shard goes into read-only mode with regards to chunk splitting.

### toks-rep

Actual MongoDB shards, which (should be) replica sets.

### pdns

Nameserver for the monster dockert infrastructure. Based on PowerDNS and Sqlite3.

## General Notes

Ruby sinatra has been used as a simple REST interface to allow dockers to insert its discovery
information into pdns. Later, this will be expanded to allow for updates across disparate
servers (or a more convential approach may be employed at that point)
