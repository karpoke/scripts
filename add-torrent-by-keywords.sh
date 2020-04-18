#!/bin/bash

# downloads the first torrent found in 1337x by using the given keywords

FILE=$(mktemp)
DOMAIN="https://1337x.to"
KW=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$*")
URL="$DOMAIN/search/$KW/1/"
wget -Ufirefox "$URL" -O "$FILE" 2>/dev/null

URLPATH=$(grep -Eo 'torrent/[^"]+' "$FILE" | head -1)
if [ -z "$URLPATH" ]; then
    logger -t "$(basename "$0")" "Torrent not found"
    exit 1
fi

URL="$DOMAIN/$URLPATH"
wget -Ufirefox "$URL" -O "$FILE" 2>/dev/null
MAGNET=$(grep -Eo 'magnet:\?[^"]+' "$FILE")
add-torrent-by-magnet.sh "$MAGNET"

FILENAME="${URL//*\//}"
notify-by-telegram.sh "$FILENAME" "$KW"

