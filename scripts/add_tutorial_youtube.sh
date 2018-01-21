#!/bin/bash -e

TEMP_FILE="/tmp/add_tutorial_youtube"
OUTPUT_FILE="add_tutorial_youtube.md"

if [[ $# -lt 2 ]]; then
  echo
  echo "Usage:   $0 \"youtube_video_id\" \"time1\" \"time2\" \"time3\" \"timeX\""
  echo "Example: $0 SKknBy5lX7I 1:10 2:10 3:30"
  echo
  exit
fi

YOUTUBE_VIDEO_ID="$1"
echo "*** $YOUTUBE_VIDEO_ID"
youtube-dl --get-title --get-duration --get-format $YOUTUBE_VIDEO_ID > $TEMP_FILE

YOUTUBE_VIDEO_NAME=`sed -n 1p $TEMP_FILE`
YOUTUBE_VIDEO_NAME_SCREENSHOT=`echo ${YOUTUBE_VIDEO_NAME} | sed 's/ /_/g;s/#//;s/|/-/'`
YOUTUBE_VIDEO_LENGTH=`sed -n 2p $TEMP_FILE`
# Add zero if time looks like "4:34" or "1:23:45" to look like "04:34" or "01:23:45"
echo $YOUTUBE_VIDEO_LENGTH | grep -q "^[0-9]:" && YOUTUBE_VIDEO_LENGTH="0${YOUTUBE_VIDEO_LENGTH}"
YOUTUBE_VIDEO_RESOLUTION=`sed -n 3p $TEMP_FILE | awk '{ print $3 }'`
rm $TEMP_FILE

cat >> $OUTPUT_FILE << EOF
### [${YOUTUBE_VIDEO_NAME}](https://youtu.be/${YOUTUBE_VIDEO_ID})
* Author: [harry durgin](https://www.youtube.com/channel/UCngiFhMSngeFwUGtsXA-17w) (https://www.facebook.com/harrydurginphotography/)
* Video Length: ${YOUTUBE_VIDEO_LENGTH}
* Video Resolution: ${YOUTUBE_VIDEO_RESOLUTION}
EOF

shift
while [[ $# -gt 0 ]]; do
  echo $1 | grep -q "^[0-9]:" && TIME="0$1" || TIME="$1"
  echo "***** $TIME"
  echo "![${YOUTUBE_VIDEO_NAME}](screenshots/${YOUTUBE_VIDEO_NAME_SCREENSHOT}-${TIME}.jpg \"${YOUTUBE_VIDEO_NAME} (${TIME})\")" >> $OUTPUT_FILE
  mpv --really-quiet --no-audio --vo=image --vo-image-jpeg-quality=70 --frames=1 --start=${TIME} https://youtu.be/${YOUTUBE_VIDEO_ID}
  mv 00000001.jpg "${YOUTUBE_VIDEO_NAME_SCREENSHOT}-${TIME}.jpg"
  shift
done

echo >> $OUTPUT_FILE
