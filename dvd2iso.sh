#!/bin/bash -e
# Create an ISO image from an optical disc (CD or DVD)
#
# Copyright 2023 Thomas M. Parks <tmparks@yahoo.com>

INPUT=/dev/cdrom
OUTPUT=dvd.iso

IFS=":,$IFS" read IGNORE1 IGNORE2 COUNT IGNORE3 IGNORE4 SIZE IGNORE5 < <(isosize --sector $INPUT)
echo COUNT=$COUNT SIZE=$SIZE
dd bs=$SIZE count=$COUNT status=progress if=$INPUT of=$OUTPUT
if cmp --quiet $INPUT $OUTPUT
then
	echo $INPUT and $OUTPUT are identical
else
	echo $INPUT and $OUTPUT differ!
fi
