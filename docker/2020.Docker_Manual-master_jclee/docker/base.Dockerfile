ARG CUDA_TAG=
FROM nvidia/cuda:${CUDA_TAG}
LABEL maintainer "Tjkim Kim <tjkim@rcv.sejong.ac.kr>"

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG C.UTF-8

ARG PYTHON_VERSION=
ARG CONDA_ENV_NAME=

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    apt-utils \
    build-essential \
    sudo \
    cmake \
    git \
    curl \
    vim \
    ca-certificates \
    libglib2.0-0 \
    libjpeg-dev \
    libpng-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    ssh \
    wget \
    unzip \
    tmux
RUN rm -rf /var/lib/apt/lists/*

RUN curl -o /tmp/miniconda.sh -sSL http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/miniconda.sh -bfp /usr/local && \
    rm -rf /tmp/miniconda.sh

RUN conda update -y conda && \
    conda create -n $CONDA_ENV_NAME python=$PYTHON_VERSION

ENV PATH /usr/local/envs/$CONDA_ENV_NAME/bin:$PATH
RUN echo "source activate ${CONDA_ENV_NAME}" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]

COPY requirements.txt /tmp/requirements.txt
RUN source activate ${CONDA_ENV_NAME} && pip install --no-cache-dir -r /tmp/requirements.txt