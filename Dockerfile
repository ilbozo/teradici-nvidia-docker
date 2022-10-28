ARG UPSTREAM_IMAGE
FROM ${UPSTREAM_IMAGE}

ARG USERNAME
ARG PUID
ARG PGID

RUN echo "user:  ${USERNAME}"
RUN echo "puid:  ${PUID}"
RUN echo "pgid:  ${PGID}"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Etc/UTC
RUN apt -y update
RUN apt -y upgrade
RUN apt install -y curl sudo
RUN apt -y install tzdata keyboard-configuration
RUN curl -1sLf https://dl.teradici.com/DeAdBCiUYInHcSTy/pcoip-client/cfg/setup/bash.deb.sh | sudo -E distro=ubuntu codename=focal bash
RUN apt install -y gnupg apt-transport-https
RUN apt install -y pcoip-client
RUN apt install -y libmfx1 libmfx-tools libva-drm2 libva-x11-2 vainfo intel-media-va-driver-non-free
# sound
RUN apt install -y --no-install-recommends alsa-base alsa-utils libsndfile1-dev && apt clean

RUN mkdir -p /etc/sudoers.d/ && \
    mkdir -p /home/${USERNAME} && \
    echo "${USERNAME}:x:${PUID}:${PGID}:${USERNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${USERNAME}:x:${PUID}:" >> /etc/group && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chown ${PUID}:${PGID} -R /home/${USERNAME}

## Set some environment variables for the current user
USER ${USERNAME}
ENV HOME /home/${USERNAME}

## Set the path for QT to find the keyboard context
ENV QT_XKB_CONFIG_ROOT /user/share/X11/xkb
#
ADD entrypoint.sh /usr/bin/
ENTRYPOINT exec /usr/bin/entrypoint.sh
