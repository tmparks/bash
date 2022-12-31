#!/bin/bash
# Find all TIFF files in the current directory and subdirectories
# and convert to JPEG. File names should be unique to avoid conflicts.
#
# Copyright 2022 Thomas M. Parks <tmparks@yahoo.com>

# Array of file paths that may contain spaces.
readarray -t FILES < <(find . -name "*.tif")
for input in "${FILES[@]}"
do
    # Remove directory and change extension.
    output=$(basename "$input" .tif).jpg
    convert "$input" -normalize "$output"
    echo $output # Show progress.
done
