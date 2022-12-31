# Copyright 2022 Thomas M. Parks <tmparks@yahoo.com>
FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        git \
        imagemagick \
    && rm --recursive --force /var/lib/apt/lists/*
