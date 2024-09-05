
IMAGE_TAG=latest

PYTHON_VERSION=3.9.6

CONDA_ENV_NAME=robot

UID:=$(shell id -u)

POS_GPUS=all

## 개인 컨테이너 이름 지정해주시길 바랍니다.
USER_NAME:=$(shell whoami)
IMAGE_NAME=sam6d
CONTAINER_NAME=sam6d


## CUDA TAG 지정
## cuda 11.1.1
# 11.1.1-cudnn8-devel-ubuntu18.04

## cuda 11.3.0
# CUDA_TAG=11.3.0-cudnn8-devel-ubuntu18.04
CUDA_TAG=11.3.0-cudnn8-devel-ubuntu20.04

## cuda 11.6.0
# 11.6.0-devel-ubuntu20.04
# CUDA_TAG=11.3.0-devel-ubuntu20.04

## cuda 12.2.2
# 12.2.2-cudnn8-devel-ubuntu20.04
# CUDA_TAG=12.2.2-cudnn8-devel-ubuntu20.04

PORT1=8813


##베이스 이미지 이름 설정
BASE_IMAGE_NAME=sam6d-base
BASE_IMAGE_TAG=11.3.0-cudnn8-devel-ubuntu20.04

##유저 이미지 이름 설정
USER_IMAGE_NAME=sam6d
USER_IMAGE_TAG=11.3.0-cudnn8-devel-ubuntu20.04


docker-base:
	$(eval IMAGE_NAME := $(IMAGE_NAME):$(CUDA_TAG))
	@nvidia-docker build -t rcv/${IMAGE_NAME} \
		--build-arg PYTHON_VERSION=${PYTHON_VERSION} \
		--build-arg CONDA_ENV_NAME=${CONDA_ENV_NAME} \
		--build-arg CUDA_TAG=${CUDA_TAG} \
		-f ./docker/base.Dockerfile \
		.

docker-user:
	$(eval IMAGE_NAME := $(IMAGE_NAME):$(CUDA_TAG))
	@nvidia-docker build -t ${USER_NAME}/${IMAGE_NAME} \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg CONDA_ENV_NAME=${CONDA_ENV_NAME} \
		--build-arg UID=${UID} \
		--build-arg USER_NAME=${USER_NAME} \
		-f ./docker/user.Dockerfile \
		.



docker-run:

	$(eval IMAGE_NAME := $(IMAGE_NAME):$(CUDA_TAG))

	@nvidia-docker run -it -u ${USER_NAME} \
		--name ${USER_NAME}_${CONTAINER_NAME} \
		-p ${PORT1}:${PORT1} \
		-e "TERM=xterm-256color" \
		-w /home/${USER_NAME}/workspace \
		-v /home/${USER_NAME}/workspace:/home/${USER_NAME}/workspace \
		-v /data:/data \
		-v /data1:/data1 \
		-v /data2:/data2 \
		-v /data3:/data3 \
		-v /data4:/data4 \
		-v /data5:/data5 \
		-v /data6:/data6 \
		-e NVIDIA_VISIBLE_DEVICES=${POS_GPUS} \
		--shm-size=32G \
		${USER_NAME}/${IMAGE_NAME} \
		/bin/bash 
	
	