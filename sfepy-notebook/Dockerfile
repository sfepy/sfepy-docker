#FROM debian:stable-slim
FROM ubuntu:20.04

ARG SFEPY_RELEASE=UNKNOWN

ARG DOCKER_LANG=en_US
ARG DOCKER_TIMEZONE=Europe/Prague

ENV LANG=$DOCKER_LANG.UTF-8 \
    LANGUAGE=$DOCKER_LANG:UTF-8 \
    LC_ALL=$DOCKER_LANG.UTF-8

ENV PATH=/opt/conda/bin:$PATH
ENV SHELL=/bin/bash

ENV DISPLAY=:99.0

USER root
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-utils \
        apt-file \
        locales \
        language-pack-en \
    && locale-gen $LANG \
    && dpkg-reconfigure -f noninteractive locales \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget bzip2 ca-certificates \
        sudo procps \
        libglib2.0-0 libxext6 libsm6 libxrender1 \
        xvfb x11-utils xauth libx11-dev qt5-default \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && adduser --disabled-password \
            --gecos "Default Sfepy user" \
            --uid 1000 \
            sfepy \
    && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && chown sfepy /opt

USER sfepy
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate base" >> ~/.bashrc \
    && conda config --set always_yes yes \
    && conda config --add channels conda-forge \
    && conda install --freeze-installed \
        nomkl \
        sfepy=${SFEPY_RELEASE} \
        mayavi \
        scikit-umfpack \
        ipyevents \
        ipywidgets \
        itkwidgets \
        jupyterlab \
        notebook \
        "nodejs>=10.0.0"\
        tini

# Install Jupyter notebook/lab extensions
RUN jupyter nbextension install mayavi --py --sys-prefix \
    && jupyter nbextension enable mayavi --py --sys-prefix \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build \
    && jupyter labextension install @bokeh/jupyter_bokeh --no-build \
    && jupyter labextension install jupyter-matplotlib --no-build \
    && jupyter labextension install jupyterlab-datawidgets --no-build \
    && jupyter labextension install itkwidgets --no-build \
    && jupyter lab build  \
    && jupyter lab clean \
    && npm cache clean --force \
    && conda uninstall nodejs \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && rm -rf /opt/conda/share/jupyter/lab/staging \
    && rm -rf /home/sfepy/.cache/yarn \
    && rm -rf /home/sfepy/.node-gyp \
    && conda clean -afy

WORKDIR /home/sfepy

COPY --chown=sfepy add-files/jupyter_notebook_config.py /etc/jupyter/
COPY --chown=sfepy add-files/bashrc /home/sfepy/.bashrc

ENTRYPOINT ["tini", "-g", "--"]
CMD ["xvfb-run", "/bin/bash"]
