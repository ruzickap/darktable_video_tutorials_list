#!/bin/bash -eux

# Main URL
URL="https://github.com/ruzickap/darktable_video_tutorials_list"
# URL which should not be checked
IGNORE_URL='assets-cdn\.github\.com'

docker run -it --rm jare/linkchecker --verbose --check-extern --no-robots --recursion-level=1 --threads=4 --ignore-url="$IGNORE_URL" $URL
