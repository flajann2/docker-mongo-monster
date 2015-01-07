#!/usr/bin/env bash
# Push images to our local repo

REPO="docker-repo:2061"
RUSER='prioridata'
RPASS='WeL0veData'

function tag_and_push {
    tag=$1
    echo "Tag and pushing $REPO/$tag"
    docker login --email='' --password=$RPASS --username=$RUSER https://$REPO
    docker tag $(docker images -q $tag) $REPO/$tag
    docker push $REPO/$tag
}


function do_all {
    tag_and_push pdns
    tag_and_push tokumx/basic
    tag_and_push tokumx/toks-s
    tag_and_push tokumx/toks-config
    tag_and_push tokumx/toks-rep
}

docker login https://$REPO && do_all
