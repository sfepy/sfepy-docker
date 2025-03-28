FROM lscr.io/linuxserver/webtop:ubuntu-xfce

LABEL maintainer="kejzlar@civ.zcu.cz"
ARG SFEPY_RELEASE

# Bootstrap Miniforge3 installation
COPY --from=condaforge/miniforge3:latest /opt/conda /opt/conda

# Set environment variables
ENV PATH=${PATH}:/opt/conda/condabin/

# Install build tools and clean up
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Update conda, install required packages, and clean up
RUN conda update -y --quiet --all \
    && conda install -y --quiet \
        ipython \
        pip \
        pyvista \
        pytest \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && conda clean -afy \
    && ln -sf /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && /opt/conda/bin/python3 -m pip install --no-cache-dir sfepy==${SFEPY_RELEASE}

# Add local files
COPY /root /

# Expose ports and define volumes
EXPOSE 3000 3001
VOLUME /config