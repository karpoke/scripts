#!/bin/bash

THIS_DIR="$(readlink -f "${BASH_SOURCE%/*}")"

MAGNET="$*"
if [ -z "$MAGNET" ]; then
    logger -t "$(basename "$0")" "Magnet not found"
    exit 1
fi

transmission-remote --add "$MAGNET" >/dev/null && echo "Ok" || echo "Error"
"$THIS_DIR/transmission-add-trackers.sh"

