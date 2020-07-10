FROM ubuntu:20.04

ARG DOCKER_LANG=en_US
ARG DOCKER_TIMEZONE=Europe/Prague

ENV LANG=$DOCKER_LANG.UTF-8 \
    LANGUAGE=$DOCKER_LANG:UTF-8 \
    LC_ALL=$DOCKER_LANG.UTF-8

WORKDIR /tmp

ARG DEBIAN_FRONTEND=noninteractive

# Install some required system tools and packages for X Windows and ssh
# Also remove the message regarding unminimize
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-utils \
        apt-file \
        locales \
        language-pack-en && \
    locale-gen $LANG && \
    dpkg-reconfigure -f noninteractive locales && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        less \
        vim \
        psmisc \
        runit \
        apt-transport-https ca-certificates \
        software-properties-common \
        man \
        sudo \
        rsync \
        libarchive-tools \
        net-tools \
        gpg-agent \
        inetutils-ping \
        zsh \
        build-essential \
        libssl-dev \
        git \
        dos2unix \
        dbus-x11 \
        \
        openssh-server \
        \
        xserver-xorg-video-dummy \
        lxde \
        x11-xserver-utils \
        xterm \
        gnome-themes-standard \
        gtk2-engines-pixbuf \
        gtk2-engines-murrine \
        libcanberra-gtk-module libcanberra-gtk3-module \
        ttf-ubuntu-font-family \
        xfonts-base xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic \
        libopengl0 mesa-utils libglu1-mesa libgl1-mesa-dri libjpeg8 libjpeg62 \
        xauth \
        x11vnc \
        \
        firefox && \
    chmod 755 /usr/local/share/zsh/site-functions && \
    apt-get -y autoremove && \
    ssh-keygen -A && \
    ln -s -f /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so && \
    perl -p -i -e 's/#?X11Forwarding\s+\w+/X11Forwarding yes/g; \
        s/#?X11UseLocalhost\s+\w+/X11UseLocalhost no/g; \
        s/#?PasswordAuthentication\s+\w+/PasswordAuthentication no/g; \
        s/#?PermitEmptyPasswords\s+\w+/PermitEmptyPasswords no/g' \
        /etc/ssh/sshd_config && \
    rm -f /etc/update-motd.d/??-unminimize && \
    rm -f /etc/xdg/autostart/lxpolkit.desktop && \
    chmod a-x /usr/bin/lxpolkit && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Miniconda Python3 with SfePy
ENV PATH=/opt/conda/bin:/usr/local/bin/:$PATH
ENV SHELL=/bin/bash

RUN curl -s -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && conda config --set always_yes yes \
    && conda config --add channels conda-forge \
    && conda install --freeze-installed \
        pip \
        setuptools \
        nomkl \
        sfepy=${SFEPY_RELEASE} \
        mayavi \
        scikit-umfpack \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && conda clean -afy

# Install websokify and noVNC
RUN pip3 install -U https://github.com/novnc/websockify/archive/60acf3c.tar.gz && \
    mkdir /usr/local/noVNC && \
    curl -s -L https://github.com/x11vnc/noVNC/archive/master.tar.gz | \
         bsdtar zxf - -C /usr/local/noVNC --strip-components 1 && \
    rm -rf /tmp/* /var/tmp/*

RUN perl -e 's/,\s*ISO_Left_Tab//g' -p -i /usr/share/X11/xkb/symbols/pc && \
    ldconfig && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

########################################################
# Customization for user and location
########################################################
# Set up user so that we do not run as root in DOCKER
ENV DOCKER_USER=sfepy \
    DOCKER_UID=9999 \
    DOCKER_GID=9999 \
    DOCKER_SHELL=/bin/zsh

ENV DOCKER_GROUP=$DOCKER_USER \
    DOCKER_HOME=/home/$DOCKER_USER \
    SHELL=$DOCKER_SHELL

# Change the default timezone to $DOCKER_TIMEZONE
# Run ldconfig so that /usr/local/lib etc. are in the default
# search path for dynamic linker
RUN groupadd -g $DOCKER_GID $DOCKER_GROUP && \
    useradd -m -u $DOCKER_UID -g $DOCKER_GID -s $DOCKER_SHELL -G sudo $DOCKER_USER && \
    echo "$DOCKER_USER:"`openssl rand -base64 12` | chpasswd && \
    echo "$DOCKER_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "$DOCKER_TIMEZONE" > /etc/timezone && \
    ln -s -f /usr/share/zoneinfo/$DOCKER_TIMEZONE /etc/localtime

ADD image/etc /etc
ADD image/usr /usr
ADD image/sbin /sbin
ADD image/home $DOCKER_HOME

RUN mkdir -p $DOCKER_HOME/.config/mozilla && \
    ln -s -f .config/mozilla $DOCKER_HOME/.mozilla && \
    touch $DOCKER_HOME/.sudo_as_admin_successful && \
    mkdir -p $DOCKER_HOME/shared && \
    mkdir -p $DOCKER_HOME/.ssh && \
    mkdir -p $DOCKER_HOME/.log && touch $DOCKER_HOME/.log/vnc.log && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

WORKDIR $DOCKER_HOME

ENV DOCKER_CMD=start_vnc

USER root
ENTRYPOINT ["/sbin/my_init", "--quiet", "--", "/sbin/setuser", "sfepy"]
CMD ["$DOCKER_CMD"]
