#!/bin/sh

MAGNET=$(hash2magnet.sh "$@")
add-torrent-by-magnet.sh "$MAGNET"

