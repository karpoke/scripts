#!/bin/bash

NEXT_SOLOLINUX_FILE="$HOME/.next_sololinux"
[ ! -s "$NEXT_SOLOLINUX_FILE" ] && logger -t "$(basename "$0")" "Error: ~/.next_sololinux not found" && exit 1

NUM=$(cat "$NEXT_SOLOLINUX_FILE")
[ -z "$NUM" ] && logger -t "$(basename "$0")" "Error: ~/.next_sololinux invalid" && exit 2

URL=$(wget -q -O- "https://www.sololinux.es/revista-digital-magazine/" | grep -Eo "https://www.sololinux.es/revista/REVISTA_SOLOLINUX_N${NUM}_[^\.]+.pdf")
[ -z "$URL" ] && logger -t "$(basename "$0")" "Error: sololinux $NUM not found" && exit 3

if wget -q "$URL"; then
    echo "$((NUM+1))" > "$HOME/.next_sololinux"
    notify-by-telegram.sh "REVISTA_SOLOLINUX_N$NUM"*.pdf "New SoloLinux N$NUM"
fi

