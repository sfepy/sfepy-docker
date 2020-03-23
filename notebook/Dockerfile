FROM debian:buster-slim

ARG SFEPY_RELEASE=2019.4

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV PATH=/opt/conda/bin:$PATH
ENV SHELL=/bin/bash

ENV USER=sfepy
ENV UID=1000
ENV HOME=/home/sfepy

ENV DISPLAY=:99

USER root

RUN apt-get update --fix-missing --no-install-recommends \
    && apt-get install -yq  \
        wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 \
        libxrender1 \
        sudo procps \
        xvfb x11-utils libx11-dev qt5-default \
    && apt-get clean

RUN adduser --disabled-password \
            --gecos "Default Sfepy user" \
            --uid ${UID} \
            ${USER} \
    && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && chown sfepy /opt

USER sfepy

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
        && /bin/bash ~/miniconda.sh -b -p /opt/conda \
        && rm ~/miniconda.sh \
        && /opt/conda/bin/conda clean -tipsy \
        && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
        && echo "conda activate base" >> ~/.bashrc

RUN conda config --set always_yes yes \
    && conda config --add channels conda-forge \
    && conda install --freeze-installed \
        nomkl \
        sfepy=${SFEPY_RELEASE} \
        mayavi \
        scikit-umfpack \
        ipyevents \
        ipywidgets \
        jupyter \
        jupyterlab \
        tini \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && conda clean -afy

# Install Jupyter notebook extensions
RUN jupyter nbextension install mayavi --py --sys-prefix \
    && jupyter nbextension enable mayavi --py --sys-prefix

WORKDIR ${HOME}

COPY add-files/jupyter_notebook_config.py /etc/jupyter/
COPY add-files/bashrc ${HOME}/.bashrc

ENTRYPOINT ["tini", "-g", "--"]
CMD ["xvfb-run", "/bin/bash"]
