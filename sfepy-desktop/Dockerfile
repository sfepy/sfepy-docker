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
RUN conda update -y --quiet --all \
    && conda install -y --quiet \
        sfepy=${SFEPY_RELEASE} \
        pytest \
        pyvista \
        ipython \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && conda clean -afy \
    && ln -sf /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

# Add local files
COPY /root /

# Ports and volumes
EXPOSE 3000 3001
VOLUME /config
