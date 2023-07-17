FROM lscr.io/linuxserver/webtop:ubuntu-xfce

LABEL maintainer="kejzlar@civ.zcu.cz"
ARG SFEPY_RELEASE
#
# Bootstraped Miniconda3 installation
#
COPY --from=continuumio/miniconda3:latest /opt/conda /opt/conda
#
# SfePy conda-forge package
#
ENV PATH=/opt/conda/condabin/:${PATH}

RUN set -x \
    && ln -sf /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && conda config --add channels conda-forge \
    && conda update -y --quiet conda \
    && conda update -y --quiet --all \
    && conda install -y --quiet \
        sfepy=${SFEPY_RELEASE} \
        pyvista \
        trame \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

# Add local files
COPY /root /

# Ports and volumes
EXPOSE 3000 3001
VOLUME /config
