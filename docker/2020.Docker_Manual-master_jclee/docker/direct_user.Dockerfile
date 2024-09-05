ARG PYTORCH="1.12.1"
ARG CUDA="11.3"
ARG CUDNN="8"
# FROM rcv/robotics:11.3.0-cudnn8-devel-ubuntu20.04
FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel
# FROM nvidia/cuda:${CUDA_TAG}
# FROM rcv/$IMAGE_NAME
LABEL maintainer "jclee <jclee@rcv.sejong.ac.kr>"

# Arguments

ARG CUDA_TAG=
ARG PYTHON_VERSION=
ARG CONDA_ENV_NAME=
ARG DEBIAN_FRONTEND=noninteractive
ARG UID=
ARG USER_NAME=

ENV LANG C.UTF-8

# 기본 apt setting
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
    tmux \
    nano
RUN rm -rf /var/lib/apt/lists/*


# conda setting
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



# user setting
RUN adduser $USER_NAME -u $UID --quiet --gecos "" --disabled-password && \
    echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME
    
# Pytorch setting
## reference URL: https://pytorch.org/get-started/previous-versions/

# 기본
# RUN source activate ${CONDA_ENV_NAME} && conda install pytorch==1.12.1 torchvision==0.13.1 -c pytorch

RUN source activate ${CONDA_ENV_NAME} && conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch


# Tensorflow setting
## reference URL: https://www.tensorflow.org/install/pip?hl=ko
# RUN source activate ${CONDA_ENV_NAME} && pip install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-2.11.0-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl

USER $USER_NAME

SHELL ["/bin/bash", "-c"]

RUN echo "source activate ${CONDA_ENV_NAME}" >> ~/.bashrc

CMD ["/bin/bash"]
