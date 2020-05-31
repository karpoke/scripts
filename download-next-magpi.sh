#!/bin/bash

NEXT_MAGPI_FILE="$HOME/.next_magpi"
[ ! -s "$NEXT_MAGPI_FILE" ] && logger -t "$(basename "$0")" "Error: ~/.next_magpi not found" && exit 1

NUM=$(cat "$NEXT_MAGPI_FILE")
[ -z "$NUM" ] && logger -t "$(basename "$0")" "Error: ~/.next_magpi invalid" && exit 2

URL=$(wget -q -O- "https://magpi.raspberrypi.org/issues/$NUM/pdf" | grep "the-magpi-issue-$NUM" | grep -Eo 'https://[^\?]+')
[ -z "$URL" ] && logger -t "$(basename "$0")" "Error: MagPi $NUM not found" && exit 3

MAGPI_FILE="MagPi$NUM.pdf"
if wget -q "$URL" -O "$MAGPI_FILE"; then
    echo "$((NUM+1))" > "$HOME/.next_magpi"
    notify-by-telegram.sh "$MAGPI_FILE" "New MagPi $NUM"
fi

