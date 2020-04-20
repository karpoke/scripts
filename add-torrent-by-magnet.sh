#!/bin/bash

MAGNET="$*"
if [ -z "$MAGNET" ]; then
    logger -t "$(basename "$0")" "Magnet not found"
    exit 1
fi

transmission-remote --add "$MAGNET" >/dev/null && echo "Ok" || echo "Error"
transmission-add-trackers.sh

