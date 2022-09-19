# FROM debian:bullseye 
FROM rust:slim-bullseye

ENV HOME /home
ENV PATH $PATH:$HOME/.cargo/bin

WORKDIR /home

RUN apt update \
    && apt-get install -y software-properties-common \
    wget \
    curl \
    gnupg2 \
    git \
    libssl-dev \
    pkg-config \
    build-essential \
    gnutls-bin \
    && rustup update \
    && rustup component add rustfmt clippy rls rust-analysis rust-src  \
    && mkdir -p ~/.cargo/bin \
    && curl -L https://github.com/rust-lang/rust-analyzer/releases/download/2022-07-04/rust-analyzer-aarch64-unknown-linux-gnu.gz | gunzip -c - > ~/.cargo/bin/rust-analyzer \
    && chmod +x ~/.cargo/bin/rust-analyzer \ 
    && cargo install cargo-edit \
    && wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0rc1.tgz \
    && tar -xf Python-3.11.0rc1.tgz \
    && rm -rf /var/lib/apt/lists/*

# build python
WORKDIR /home/Python-3.11.0rc1
RUN apt update && apt install -y zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libreadline-dev \
    libffi-dev \
    libsqlite3-dev \
    libbz2-dev \
    && ./configure --enable-optimizations \
    && make -j 8 \
    && make install \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt install -y nodejs \
    && pip3 install python-lsp-server pyright \
    && ln -sf /usr/local/bin/python3 /usr/local/bin/python \
    && ln -sf /usr/local/bin/pip3 /usr/local/bin/pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["/bin/bash"]
# XXX USER
# emacs -nw --user ''
