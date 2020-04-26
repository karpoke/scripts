#!/bin/bash

# downloads the first torrent found in 1337x given some keywords

# torrent's page

DOMAIN="https://1337x.to"
KW=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$*")
URL="$DOMAIN/search/$KW/1/"
TEMPFILE="/tmp/$KW.13337x.tmp"
wget -q -Ufirefox "$URL" -O "$TEMPFILE"

# torrent file

URLPATH=$(grep -Eo 'torrent/[^"]+' "$TEMPFILE" | head -1)
if [ -z "$URLPATH" ]; then
    logger -t "$(basename "$0")" "Torrent not found"
    exit 1
fi
URL="$DOMAIN/$URLPATH"
TORRENT="/tmp/$KW.torrent"
wget -q -Ufirefox "$URL" -O "$TORRENT"


transmission-remote --add "$TEMPFILE" >/dev/null && echo "Ok" || echo "Error"
transmission-add-trackers.sh
notify-by-telegram.sh "$TORRENT" "$KW"

rm -f "$TEMPFILE" "$TORRENT"

