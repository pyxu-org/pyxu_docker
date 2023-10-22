# [2023.10.07 Sepand] 20.04 chosen over 22.04
# Reason: we want DrJIT (via PyPI) to work out of the box with system's LLVM.
FROM nvidia/cuda:12.2.0-devel-ubuntu20.04
SHELL ["/bin/bash", "-c"]

LABEL maintainer="Sepand KASHANI <sepand@kashani.ch>"

### Clean image with system tools
ENV DEBIAN_FRONTEND=noninteractive
RUN    apt update \
    && apt install --yes --no-install-recommends build-essential \
                                                 ca-certificates \
                                                 clang \
                                                 dpkg \
                                                 gnupg2 \
                                                 llvm \
                                                 nano \
                                                 wget \
    && rm -rf /var/lib/apt/lists/*

### Install additional programs in ~/tools
WORKDIR /root
RUN    mkdir ~/tools \
    && cd ~/tools \
    # [INSTALL] conda =========================================================
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && sh ./Miniconda3-latest-Linux-x86_64.sh -b -s -p ~/tools/miniconda3 \
    && rm ./Miniconda3-latest-Linux-x86_64.sh

### Configure all tools installed
WORKDIR /root
COPY config/.bashrc        .bashrc
COPY config/.bash_aliases  .bash_aliases

### Create directory to mount host shares
RUN mkdir ~/HOST

### Install Pyxu
RUN    source .bash_aliases \
    && conda create --quiet --yes --name pyxu python=3.11 \
    && conda run --name pyxu python3 -m pip install pyxu[complete]

### Serve a Jupyter-lab interface to users
EXPOSE 8888
CMD    source .bash_aliases \
    && conda run --name pyxu python3 -m jupyter lab --ip='*' \
                                                    --port=8888 \
                                                    --no-browser \
                                                    --allow-root \
                                                    --NotebookApp.token='' \
                                                    --NotebookApp.password=''
