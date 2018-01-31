#!/bin/bash -eu

DESTINATION_DIRECTORY="/var/tmp/test"

for URL in `sed -n 's/^###.*(\(.*\))/\1/p' ../README.md`; do
  echo "*** $URL"
  youtube-dl $URL --restrict-filenames -o "$DESTINATION_DIRECTORY/%(uploader)s-%(title)s-%(id)s.%(ext)s"
done
