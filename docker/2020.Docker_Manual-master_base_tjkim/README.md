# Docker

> 주의사항. docker 사용 전에 반드시 각 팀 사수분들에게 교육을 이수 받으시고 사용하시길 바랍니다.

---
## 빠른 실행 방법

1. Python library들을 설치해둔 기본 docker image는 `rcv/robotics:${CUDA_TAG}` 에 만들어져 있다.

2. 개인 docker image 생성
    ```sh
    $ make docker-user -e CUDA_TAG={cuda 버전}
    ```

    > 적용 가능한 cuda 버전. 2023.03.02 A100 기준
    ```
    # cuda 11.1.1
    11.1.1-cudnn8-devel-ubuntu18.04

    # cuda 11.3.0
    11.3.0-cudnn8-devel-ubuntu18.04
    11.3.0-cudnn8-devel-ubuntu20.04

    # cuda 11.6.0
    11.6.0-devel-ubuntu20.04
    ```

3. 개인 docker image를 바탕으로 container 실행

    #### 자신은 잘 모르면 질문하세요 (그냥 멋대로 실행하면 쓰레기 컨테이너가 많이 만들어 집니다 
    
    #### 잘 아시는 분은 아래 명령어로 실행! (단, 해당 포트 중복되지 않게 주의하세요. 중복되면 컨테이너 안만들어지고 정리해야합니다)
    ```sh
    $ make docker-run -e PORT1={port_번호}
    ```


사용되는 명령어는 아래와 같습니다.
```sh
$ make docker-base
$ make docker-user
$ make docker-run
```
---
## 유저 이미지 적용 방법
> 해당 버전에서는 torch와 tensorflow 설치를 `make docker-user`에서 진행합니다.

```make docker-user```는 베이스 이미지를 기반으로 유저별 특화된 이미지를 생성하기 위한 명령어로 자세한 구성은 `docker/user.Dockerfile`을 참고하시면 됩니다.


torch 및 tf 버전 변경시, `docker/user.Dockerfile` 중 아래 코드를 변경하셔야 합니다.

```
# Pytorch
## reference URL: https://pytorch.org/get-started/previous-versions/
RUN source activate ${CONDA_ENV_NAME} && conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch

# Tensorflow
## reference URL: https://www.tensorflow.org/install/pip?hl=ko
RUN source activate ${CONDA_ENV_NAME} && pip install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-2.11.0-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl

```
>torch는 cuda 버전에 따라 최적화된 버전이 다르기 때문에 [previous-version](https://pytorch.org/get-started/previous-versions/)에서 확인하시고 설치 진행하기길 바랍니다.


---
## 베이스 이미지 적용 방법
```make docker-base```는 기본 base 이미지를 구성하기 위한 명령어로 자세한 구성은 `docker/base.Dockerfile`을 참고하시면 됩니다.

base images의 cuda 버전을 변경하고 싶으시다면 `Makefile`안 `CUDA_TAG`를 통해 변경 가능합니다. 적용 가능한 CUDA 버전은 아래와 같습니다.
```
# cuda 11.1.1
11.1.1-cudnn8-devel-ubuntu18.04

# cuda 11.3.0
11.3.0-cudnn8-devel-ubuntu18.04
11.3.0-cudnn8-devel-ubuntu20.04

# cuda 11.6.0
11.6.0-devel-ubuntu20.04
```

참고. 다른 CUDA 버전이 필요하신 분들은 Dokcer hub를 통해 다운 받으셔서 설치하시면 됩니다.

---

## Python Library

1. Docker images에 이미 설치된 library를 지울때
    기존 이미지에 깔린 라이브러리를 삭제할 경우에는 root로 컨테이너 진입해서 지우셔야합니다.

    ```sh
    (Server) $ docker exec -it -u root Container_이름 /bin/bash
        
    (Docker) root $ pip uninstall Python_Library
    (Docker) root $ pip list | grep Python_Library
    ```

2. Docker images에 새로 library를 설치할 때

    ```sh
    (Docker) user $ pip install --user Python_Library
    (Docker) user $ pip list | grep Python_Library
    ```

## Maintainer

- [TaeJoo Kim](mailto:tjkim@rcv.sejong.ac.kr)
