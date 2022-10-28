#!/bin/bash
set -ex

if command -v nvidia-smi; then
    echo "NVidia driver detected, using nvidia/cudagl image"
    UPSTREAM_IMAGE=nvidia/cudagl:11.4.2-runtime-ubuntu20.04
else
    echo "NVidia driver not found, using regular ubuntu image"
    UPSTREAM_IMAGE=ubuntu:20.04
fi

docker build --progress plain \
    -t pcoip-client \
    --tag=audio:0.0.1 \
    --build-arg USERNAME=$LOGNAME \
    --build-arg PUID=$(id -u) \
    --build-arg PGID=$(id -g) \
    --build-arg UPSTREAM_IMAGE=${UPSTREAM_IMAGE} \
    .
