#!/usr/bin/env bash
# Push images to our local repo

REPO="docker-repo:2061"

function tag_and_push {
    tag=$1
    echo "Tag and pushing $REPO/$tag"
    docker tag $(docker images -q $tag) $REPO/$tag
    docker push $REPO/$tag
}

tag_and_push pdns
tag_and_push tokumx/basic
tag_and_push tokumx/toks-s
tag_and_push tokumx/toks-config
tag_and_push tokumx/toks-rep
