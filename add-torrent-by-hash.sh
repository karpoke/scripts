#!/bin/bash

THIS_DIR="$(readlink -f "${BASH_SOURCE%/*}")"
CONVERT_SCRIPT="${THIS_DIR}/hash2magnet.sh"

if [ ! -x "$CONVERT_SCRIPT" ]; then
    echo "Error: cannot run '$CONVERT_SCRIPT'"
    exit
fi

MAGNET=$($CONVERT_SCRIPT "$@")
transmission-remote --add "$MAGNET"

