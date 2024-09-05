
IMAGE_TAG=latest

PYTHON_VERSION=3.8

CONDA_ENV_NAME=tr3d

UID:=$(shell id -u)

POS_GPUS=all

## 개인 컨테이너 이름 지정해주시길 바랍니다.
USER_NAME:=$(shell whoami)



## CUDA TAG 지정
## cuda 11.1.1
# 11.1.1-cudnn8-devel-ubuntu18.04

## cuda 11.3.0
# CUDA_TAG=11.3.0-cudnn8-devel-ubuntu18.04
CUDA_TAG=11.3.0-cudnn8-devel-ubuntu20.04


PORT1=8815


## 베이스 이미지 이름 설정
BASE_IMAGE_NAME=base

## 유저 이미지 이름 설정
USER_IMAGE_NAME=mm3d

## 다른 데서 바로 가져다 써서 만들 유저 이미지 이름 설정
DIRECT_USER_IMAGE_NAME=mm3d

CONTAINER_NAME=mm3d

docker-base:
	$(eval IMAGE_NAME := $(BASE_IMAGE_NAME):$(CUDA_TAG))
	@nvidia-docker build -t rcv/${IMAGE_NAME} \
		--build-arg PYTHON_VERSION=${PYTHON_VERSION} \
		--build-arg CONDA_ENV_NAME=${CONDA_ENV_NAME} \
		--build-arg CUDA_TAG=${CUDA_TAG} \
		-f ./docker/base.Dockerfile \
		.

docker-user:
	$(eval IMAGE_NAME := $(USER_IMAGE_NAME):$(CUDA_TAG))
	@nvidia-docker build -t ${USER_NAME}/${IMAGE_NAME} \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg CONDA_ENV_NAME=${CONDA_ENV_NAME} \
		--build-arg UID=${UID} \
		--build-arg USER_NAME=${USER_NAME} \
		-f ./docker/user.Dockerfile \
		.


docker-direct_user:
	$(eval IMAGE_NAME := $(DIRECT_USER_IMAGE_NAME):$(CUDA_TAG))
	@nvidia-docker build -t ${USER_NAME}/${IMAGE_NAME} \
		--build-arg PYTHON_VERSION=${PYTHON_VERSION} \
		--build-arg CONDA_ENV_NAME=${CONDA_ENV_NAME} \
		--build-arg UID=${UID} \
		--build-arg USER_NAME=${USER_NAME} \
		-f ./docker/direct_user.Dockerfile \
		.



docker-run:

	$(eval IMAGE_NAME := $(DIRECT_USER_IMAGE_NAME):$(CUDA_TAG))

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
	
	