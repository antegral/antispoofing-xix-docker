FROM docker.io/nvidia/cuda:11.7.0-cudnn8-devel-ubuntu20.04

WORKDIR /

RUN apt-get update && apt install -y python3.8-dev python3-pip

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117

RUN pip install -f https://dl.fbaipublicfiles.com/vissl/packaging/apexwheels/py38_cu102_pyt181/download.html apex

RUN apt install fonts-dejavu-core rsync git jq moreutils -y && apt-get clean

RUN git clone https://github.com/xix-ai/antispoofing app

RUN git clone --recursive https://github.com/facebookresearch/vissl.git app/vissl && \
        cd /app/vissl && \
        git checkout v0.1.6 && \
        git checkout -b v0.1.6 && \
        pip install --progress-bar off -r requirements.txt

WORKDIR /app/vissl

RUN pip install opencv-python

RUN pip uninstall -y classy_vision && \
        pip install classy-vision@https://github.com/facebookresearch/ClassyVision/tarball/4785d5ee19d3bcedd5b28c1eb51e>

RUN pip uninstall -y fairscale && \
        pip install fairscale==0.4.6

RUN pip install -e ".[dev]"

RUN python3.8 -c 'import vissl, apex'
