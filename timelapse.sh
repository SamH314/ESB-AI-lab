#!/bin/bash

set -e

DATE=$(date -u +"%Y-%m-%d %H:%M:%SZ")
SNAPSHOTS_DIR=/home/pi/Pics
SNAPSHOT_PATH="$SNAPSHOTS_DIR/$DATE.jpg"
CURRENT_PATH="$SNAPSHOTS_DIR/current.jpg"

echo "$DATE"
mkdir -p "$SNAPSHOTS_DIR"
libcamera-jpeg -o "$SNAPSHOT_PATH"


