# [2023.10.07 Sepand] 20.04 chosen over 22.04
# Reason: we want DrJIT (via PyPI) to work out of the box with system's LLVM.
FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]

LABEL maintainer="Sepand KASHANI <sepand@kashani.ch>"

### Clean image with system tools
ENV DEBIAN_FRONTEND=noninteractive
RUN    apt update \
    && apt install --yes --no-install-recommends apt-file \
                                                 bash-completion \
                                                 build-essential \
                                                 byobu \
                                                 ca-certificates \
                                                 clang \
                                                 curl \
                                                 detox \
                                                 dpkg \
                                                 fzf \
                                                 git \
                                                 gnupg2 \
                                                 graphviz \
                                                 htop \
                                                 less \
                                                 llvm \
                                                 nano \
                                                 ncdu \
                                                 pandoc \
                                                 python3 \
                                                 rsync \
                                                 tmux \
                                                 wget \
    && rm -rf /var/lib/apt/lists/*

### Install additional programs in ~/tools
WORKDIR /root
RUN    mkdir ~/tools \
    && cd ~/tools \
    # [INSTALL] starship ======================================================
    && wget https://starship.rs/install.sh \
    && sh ./install.sh --yes \
    && rm ./install.sh \
    # [INSTALL] lsd ===========================================================
    && wget https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz \
    && tar -xzf ./lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz \
    && mv ./lsd-v1.0.0-x86_64-unknown-linux-gnu/lsd ./lsd \
    && rm -rf ./lsd-v1.0.0-x86_64-unknown-linux-gnu* \
    # [INSTALL] git-delta =====================================================
    && wget https://github.com/dandavison/delta/releases/download/0.16.5/delta-0.16.5-x86_64-unknown-linux-gnu.tar.gz \
    && tar -xzf ./delta-0.16.5-x86_64-unknown-linux-gnu.tar.gz \
    && mv ./delta-0.16.5-x86_64-unknown-linux-gnu/delta ./delta \
    && rm -rf ./delta-0.16.5-x86_64-unknown-linux-gnu* \
    # [INSTALL] lazygit =======================================================
    && LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && wget "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar -xzf "./lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" lazygit \
    && rm "./lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    # [INSTALL] conda =========================================================
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && sh ./Miniconda3-latest-Linux-x86_64.sh -b -s -p ~/tools/miniconda3 \
    && rm ./Miniconda3-latest-Linux-x86_64.sh

### Configure all tools installed
WORKDIR /root
COPY config/.bash_aliases  .bash_aliases
COPY config/.condarc       .condarc
COPY config/.gitconfig     .gitconfig
COPY config/starship.toml  .config/starship.toml

### Create directory to mount host shares
RUN mkdir ~/HOST

### Keep container running. (Reason: interactive use.)
CMD ["tail", "-f", "/dev/null"]
