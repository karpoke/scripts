#!/bin/bash

if [[ ! "$1" =~ xt=urn:btih:([^&/]+) ]]; then
    echo "Error: not a valid magnet link"
    exit
fi

aria2c --bt-metadata-only=true --bt-save-metadata=true -q "$1"
# saved as "$HASH.torrent"

# aria2c "$hash.torrent" -S

HASH=${BASH_REMATCH[1],,}  # also, convert to lowercase (bash +4.0, non-posix)
if [[ "$1" =~ dn=([^&/]+) ]];then
  FILENAME=${BASH_REMATCH[1]}
  if [ -n "$FILENAME" ]; then
      mv "${HASH}.torrent" "${FILENAME}.torrent"
  fi
fi

