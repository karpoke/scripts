#!/bin/bash

THIS_DIR="$(readlink -f "${BASH_SOURCE%/*}")"
CONVERT_SCRIPT="${THIS_DIR}/hash2magnet.sh"

if [ ! -x "$CONVERT_SCRIPT" ]; then
    echo "Error: cannot run '$CONVERT_SCRIPT'"
    exit
fi

MAGNET=$($CONVERT_SCRIPT "$@")
if [ -z "$MAGNET" ]; then
    echo "Magnet not found"
    exit 1
fi

transmission-remote --add "$MAGNET" >/dev/null && echo "Ok" || echo "Error"

