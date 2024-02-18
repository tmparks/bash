#!/bin/bash -e
# Create an ISO image from an optical disc (CD-ROM or DVD)
#
# Copyright 2023-2024 Thomas M. Parks <tmparks@yahoo.com>

INPUT=/dev/cdrom
OUTPUT=dvd.iso
MAPFILE=dvd.map

if [ $# -ge 1 ]
then
    OUTPUT=$1
    MAPFILE=$(dirname $1)/$(basename --suffix=.iso $1).map
fi

IFS=":,$IFS" read IGNORE1 IGNORE2 COUNT IGNORE3 IGNORE4 SIZE IGNORE5 < <(isosize --sector $INPUT)
echo COUNT=$COUNT SIZE=$SIZE
ddrescue --verbose --sector-size=$SIZE --idirect $INPUT $OUTPUT $MAPFILE
