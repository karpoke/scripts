#!/bin/bash

# downloads the first torrent found in 1337x given some keywords

# search page

DOMAIN="https://1337x.to"
KW=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$*")
URL="$DOMAIN/search/$KW/1/"
TEMPFILE="/tmp/$KW.13337x.tmp"
wget -q -Ufirefox "$URL" -O "$TEMPFILE"

# torrent's page

URLPATH=$(grep -Eo 'torrent/[^"]+' "$TEMPFILE" | head -1)
if [ -z "$URLPATH" ]; then
    logger -t "$(basename "$0")" "Torrent not found"
    exit 1
fi
URL="$DOMAIN/$URLPATH"
wget -q -Ufirefox "$URL" -O "$TEMPFILE"

# add magnet

MAGNET=$(grep -Eo 'magnet[^"]+' "$TEMPFILE" | head -1)

service transmission-daemon status >/dev/null 2>&1 || service transmission-daemon start

if transmission-remote --add "$MAGNET" >/dev/null; then
    notify-by-telegram.sh "Found and added $KW"
    transmission-add-trackers.sh
    transmission-prune-torrents.sh
else
    logger -t "$(basename "$0")" "Error adding torrent"
fi

rm -f "$TEMPFILE"

