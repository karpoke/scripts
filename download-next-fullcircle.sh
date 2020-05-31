#!/bin/bash

NEXT_FULL_CIRCLE_FILE="$HOME/.next_full_circle"
[ ! -s "$NEXT_FULL_CIRCLE_FILE" ] && logger -t "$(basename "$0")" "Error: ~/.next_full_circle not found" && exit 1

NUM=$(cat "$NEXT_FULL_CIRCLE_FILE")
[ -z "$NUM" ] && logger -t "$(basename "$0")" "Error: ~/.next_full_circle invalid" && exit 2

FULL_CIRCLE_FILE="issue${NUM}_en.pdf"
URL="https://dl.fullcirclemagazine.org/$FULL_CIRCLE_FILE"
if wget -q "$URL" -O "$FULL_CIRCLE_FILE"; then
    echo "$((NUM+1))" > "$HOME/.next_full_circle"
    notify-by-telegram.sh "$FULL_CIRCLE_FILE" "New Full Circle $NUM"
fi

