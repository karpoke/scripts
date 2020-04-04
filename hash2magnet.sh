#!/bin/bash

HASH="$1"

shift

[ -n "$*" ] && NAME="&dn=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$*")"

for TRACKER in $(curl -s -# https://newtrackon.com/api/stable | sed '/^$/d'); do
    TRACKERS="${TRACKERS}&tr=${TRACKER}"
done

MAGNET="magnet:?xt=urn:btih:${HASH}${NAME}${TRACKERS}"

echo "$MAGNET"

