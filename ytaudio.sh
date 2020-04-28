#!/bin/sh

# --embed-thumbnail
# ERROR: Only mp3 and m4a/mp4 are supported for thumbnail embedding for now.

youtube-dl \
    --quiet \
    --format best \
    --extract-audio \
    --audio-format best \
    --metadata-from-title "%(artist)s - %(title)s" \
    --output "%(title)s.%(ext)s" \
    "$1"

