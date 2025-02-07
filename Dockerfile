# Copyright 2022-2025 Thomas M. Parks <tmparks@yahoo.com>
FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        gddrescue \
        git \
        icedax \
        imagemagick \
    && rm --recursive --force /var/lib/apt/lists/*

USER ubuntu
WORKDIR /home/ubuntu
