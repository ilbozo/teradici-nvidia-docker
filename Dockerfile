ARG UPSTREAM_IMAGE="nvidia/cudagl:11.4.2-runtime-ubuntu20.04"
FROM ${UPSTREAM_IMAGE}

ARG USERNAME
ARG PUID
ARG PGID

RUN apt-get update && \
    apt-get install -y curl \
        lsb-release \
        sudo \
        libwebkitgtk-1.0 \
        iptables \
        net-tools
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata keyboard-configuration
# Use the following two lines to install the Teradici repository package
RUN curl -1sLf https://dl.teradici.com/DeAdBCiUYInHcSTy/pcoip-client/cfg/setup/bash.deb.sh | sudo -E distro=ubuntu codename=focal bash

# Uncomment the following line to install Beta client builds from the internal repository
#RUN echo "deb [arch=amd64] https://downloads.teradici.com/ubuntu bionic-beta non-free" > /etc/apt/sources.list.d/pcoip.list

# Install apt-transport-https to support the client installation
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y apt-transport-https

# Install the client application
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y pcoip-client

# Setup a functional user within the docker container with the same permissions as your local user.
# Replace 1000 with your user / group id
# Replace ${USERNAME} with your local username
RUN mkdir -p /etc/sudoers.d/ && \
    mkdir -p /home/${USERNAME} && \
    echo "${USERNAME}:x:${PUID}:${PGID}:${USERNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${USERNAME}:x:${PUID}:" >> /etc/group && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chown ${PUID}:${PGID} -R /home/${USERNAME}

ARG ENABLE_PULSESECURE=0
ENV ENABLE_PULSESECURE=${ENABLE_PULSESECURE}

ADD LICENSE ps-pulse-linux-*.deb /tmp/
RUN bash -c "if [[ $ENABLE_PULSESECURE == 1 ]]; then dpkg -i /tmp/ps-pulse-*.deb; fi;"

# Set some environment variables for the current user
USER ${USERNAME}
ENV HOME /home/${USERNAME}

# Set the path for QT to find the keyboard context
ENV QT_XKB_CONFIG_ROOT /user/share/X11/xkb

ADD entrypoint.sh /usr/bin/
ENTRYPOINT exec /usr/bin/entrypoint.sh
