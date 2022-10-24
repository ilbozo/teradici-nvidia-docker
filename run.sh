#!/bin/bash
mkdir -p .logs
mkdir -p .config

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
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        pcoip-client
else
    docker run -it \
        --privileged \
        --cap-add=NET_ADMIN \
        --device /dev/net/tun \
        --device /dev/snd audio:0.0.1 \
        --rm \
        -v $(pwd)/.config/:/home/$LOGNAME/.config/Teradici \
        -v $(pwd)/.logs:/tmp/Teradici/$LOGNAME/PCoIPClient/logs \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        pcoip-client
fi