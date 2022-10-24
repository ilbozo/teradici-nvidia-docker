#!/bin/bash
mkdir -p .logs
mkdir -p .config
mkdir -p .pulse_secure

xhost +local:docker

if command -v nvidia-smi; then
    docker run -it \
        --gpus=all \
        --privileged \
        --cap-add=NET_ADMIN \
        --device /dev/net/tun \
        --rm \
        -v $(pwd)/.config/:/home/$LOGNAME/.config/Teradici \
        -v $(pwd)/.logs:/tmp/Teradici/$LOGNAME/PCoIPClient/logs \
        -v $(pwd)/.pulse_secure:/root/.pulse_secure \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        pcoip-client
else
    docker run -it \
        --privileged \
        --cap-add=NET_ADMIN \
        --device /dev/net/tun \
        --rm \
        -v $(pwd)/.config/:/home/$LOGNAME/.config/Teradici \
        -v $(pwd)/.logs:/tmp/Teradici/$LOGNAME/PCoIPClient/logs \
        -v $(pwd)/.pulse_secure:/root/.pulse_secure \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        pcoip-client
fi