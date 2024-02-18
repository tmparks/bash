#!/bin/bash -e
# Create audio files from a CD
#
# Copyright 2024 Thomas M. Parks <tmparks@yahoo.com>

export CDDA_DEVICE=/dev/cdrom
BASE_NAME=track

cdda2wav -alltracks -no-infofile $BASE_NAME
