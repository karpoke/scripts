#!/bin/bash

# downloads the first torrent found in 1337x by using the given keywords

FILE=$(mktmp)
DOMAIN="https://1337x.to"
KW=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$*")
URL="$DOMAIN/search/$KW/1/"
wget -Ufirefox "$URL" -O "$FILE"
PATH=$(grep -Eo '/torrent/[^"]+' "$FILE" | head -1)
URL="$DOMAIN/$PATH"
wget -Ufirefox "$URL" -O "$FILE"
MAGNET=$(grep -Eo 'magnet:\?[^"]+' "$FILE")
transmission-remote --add "$MAGNET"
