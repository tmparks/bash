#!/bin/sh
# Download recent images from the Bing archive.
# Through trial and error, it has been determined that
# no more than 15 recent images are available for download.
#
# The XML and RSS responses provide links to 1366x768 images.
# The JSON response provides links to 1920x1080 images.
#
# Copyright 2017 Thomas M. Parks <tmparks@yahoo.com>

BASE_URL='https://www.bing.com'
JSON_FILE=$(mktemp)

for QUERY_URL in \
	'/HPImageArchive.aspx?format=js&idx=0&n=7&mkt=en-US' \
	'/HPImageArchive.aspx?format=js&idx=7&n=8&mkt=en-US'
do
	# Get JSON file with URLs for recent images.
	curl --silent "$BASE_URL$QUERY_URL" > $JSON_FILE

	# Extract list of URLs from JSON file and get images.
	for IMAGE_URL in $( \
		egrep --only-matching --regexp='"url":"[^"]*"' "$JSON_FILE" | \
		egrep --only-matching --regexp='[-_/A-Za-z0-9]*.jpg' )
	do
		echo $IMAGE_URL
		curl --silent --remote-name "$BASE_URL$IMAGE_URL"
	done
done

rm "$JSON_FILE"
