ARG UPSTREAM_IMAGE
FROM ${UPSTREAM_IMAGE}
ARG USERNAME
ARG PUID
ARG PGID

RUN echo "user:  ${USERNAME}"
RUN echo "puid:  ${PUID}"
RUN echo "pgid:  ${PGID}"


RUN apt-get -y update
RUN apt install -y curl sudo
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata keyboard-configuration
RUN curl -1sLf https://dl.teradici.com/DeAdBCiUYInHcSTy/pcoip-client/cfg/setup/bash.deb.sh | sudo -E distro=ubuntu codename=focal bash
RUN apt install -y gnupg apt-transport-https
RUN apt install -y pcoip-client

RUN mkdir -p /etc/sudoers.d/ && \
    mkdir -p /home/${USERNAME} && \
    echo "${USERNAME}:x:${PUID}:${PGID}:${USERNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${USERNAME}:x:${PUID}:" >> /etc/group && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chown ${PUID}:${PGID} -R /home/${USERNAME}

RUN useradd -ms /bin/bash ${USERNAME}
USER toto_user

## Set some environment variables for the current user
USER ${USERNAME}
ENV HOME /home/${USERNAME}

## Set the path for QT to find the keyboard context
ENV QT_XKB_CONFIG_ROOT /user/share/X11/xkb
#
ADD entrypoint.sh /usr/bin/
ENTRYPOINT exec /usr/bin/entrypoint.sh
