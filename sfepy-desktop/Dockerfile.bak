FROM lscr.io/linuxserver/webtop:ubuntu-xfce

LABEL maintainer="kejzlar@civ.zcu.cz"
ARG SFEPY_RELEASE
#
# Bootstraped miniforge3 installation
#
COPY --from=condaforge/miniforge3:latest /opt/conda /opt/conda
#
# Install sfepy & tools packages
#
ENV PATH=${PATH}:/opt/conda/condabin/
#
# Pip wheels build support
#
RUN apt-get update && apt-get install -y \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
#
RUN conda update -y --quiet --all \
    && conda install -y --quiet \
        pip \
        pytest \
        pyvista \
        ipython \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && conda clean -afy \
    && ln -sf /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && /opt/conda/bin/python3 -m pip install --no-cache-dir sfepy==${SFEPY_RELEASE}

# Add local files
COPY /root /

# Ports and volumes
EXPOSE 3000 3001
VOLUME /config
