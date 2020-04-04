#!/bin/bash

THIS_DIR="$(readlink -f "${BASH_SOURCE%/*}")"
MAGNET=$("${THIS_DIR}/hash2magnet.sh" "$@")
"$THIS_DIR/add-torrent-by-magnet.sh" "$MAGNET"

