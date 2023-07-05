#!/bin/zsh

docker run -it -d \
    --restart=always \
    --name=firmware-analysis \
    --privileged \
    -v /home/upwind/ubuntu-share:/home/share \
    upw1nd/firmware-analysis-docker-v2 \
    /bin/bash