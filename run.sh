#!/bin/bash
user=$(id -u)
group=$(id -g)
mkdir -p .logs
mkdir -p .config


xhost +local:docker

if command -v nvidia-smi
then
    docker run -it \
        --gpus=all \
        --privileged \
        --cap-add=NET_ADMIN \
        --device /dev/net/tun \
        -e PULSE_SERVER=unix:/run/user/"$user"/pulse/native \
        -u "$user":"$group" \
        --rm \
        -v "$(pwd)"/.config/:/home/"$LOGNAME"/.config/Teradici \
        -v "$(pwd)"/.logs:/tmp/Teradici/"$LOGNAME"/PCoIPClient/logs \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY="$DISPLAY" \
        pcoip-client
else
    docker run -it \
        --privileged \
        --cap-add=NET_ADMIN \
        --device /dev/net/tun \
        --device /dev/snd \
        --rm \
        -v "$(pwd)"/.config/:/home/"$LOGNAME"/.config/Teradici \
        -v "$(pwd)"/.logs:/tmp/Teradici/"$LOGNAME"/PCoIPClient/logs \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY="$DISPLAY" \
        pcoip-client
fi
