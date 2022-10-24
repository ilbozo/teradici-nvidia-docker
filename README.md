# Teradici Docker Client
Teradici client on linux with optional nvidia-docker on nvidia GPUs. 
Fork of the animal-logic repo https://github.com/AnimalLogic/teradici-nvidia-docker. \
As the official client only works in ubuntu-22.04 this docker solution makes it available on more distros. \
Tested on Fedora 36/37 and Rocky 8.5

## Getting Started
Install `docker` on your linux box. If you have a NVidia card please follow all the instructions there to install NVidia Docker: https://github.com/NVIDIA/nvidia-docker

## Build
Run `./build.sh` to build the docker image using the current user name and id

## Run
Run `./run.sh` to run the teradici client

Reach to the Teradici window and connect away!
