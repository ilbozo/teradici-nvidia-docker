#!/bin/bash
set -ex

UPSTREAM_IMAGE=ubuntu:20.04

docker build --progress plain \
    -t pcoip-client \
    --build-arg USERNAME=$LOGNAME \
    --build-arg PUID=$(id -u) \
    --build-arg PGID=$(id -g) \
    --build-arg UPSTREAM_IMAGE=${UPSTREAM_IMAGE} \
    .
