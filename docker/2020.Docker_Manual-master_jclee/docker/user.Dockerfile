ARG IMAGE_NAME=

FROM rcv/robotics:11.3.0-cudnn8-devel-ubuntu20.04
# FROM rcv/$IMAGE_NAME
# FROM dgkim/robotics:11.3.0-cudnn8-devel-ubuntu18.04 

ARG CONDA_ENV_NAME=
ARG UID=
ARG USER_NAME=

RUN echo ${CONDA_ENV_NAME} ${USER_NAME} ${UID}

RUN adduser $USER_NAME -u $UID --quiet --gecos "" --disabled-password && \
    echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME
# RUN sudo adduser jclee -u 1027 --quiet --gecos "" --disabled-password && \
#     echo "jclee ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/jclee && \
#     sudo chmod 0440 /etc/sudoers.d/jclee
    
# Pytorch
## reference URL: https://pytorch.org/get-started/previous-versions/
#기본
# RUN source activate ${CONDA_ENV_NAME} && conda install pytorch==1.12.1 torchvision==0.13.1 -c pytorch
RUN source activate ${CONDA_ENV_NAME} && conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch


# Tensorflow
## reference URL: https://www.tensorflow.org/install/pip?hl=ko
# RUN source activate ${CONDA_ENV_NAME} && pip install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-2.11.0-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl

USER $USER_NAME

SHELL ["/bin/bash", "-c"]

RUN echo "source activate ${CONDA_ENV_NAME}" >> ~/.bashrc

CMD ["/bin/bash"]
