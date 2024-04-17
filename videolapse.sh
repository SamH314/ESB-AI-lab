#!/bin/bash

set -e

DATE=$(date +"%Y-%m-%d %H:%M:%S")
echo "$DATE" 
SNAPSHOTS_DIR=/home/pi/vids
SNAPSHOT_PATH="$SNAPSHOTS_DIR/$DATE.h264"
CURRENT_PATH="$SNAPSHOTS_DIR/current.h264"
SNAPSHOT_PATH_MP4="$SNAPSHOTS_DIR/$DATE.mp4"
SNAPSHOT_PATH_RAW="$SNAPSHOTS_DIR/$DATE.raw"

mkdir -p "$SNAPSHOTS_DIR"

libcamera-vid --width 1280 --height 720 --level 4.2 --denoise cdn_off --framerate 120  -n -t 30000 -o "$SNAPSHOT_PATH" 
#libcamera-vid -n -t 60000 -o "$SNAPSHOT_PATH" 
#libcamera-raw -n -t 60000 -o "$SNAPSHOT_PATH_RAW" 
ffmpeg -framerate 120 -i "$SNAPSHOT_PATH" -c copy "$SNAPSHOT_PATH_MP4" 
rm "$SNAPSHOT_PATH"
