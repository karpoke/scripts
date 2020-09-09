#!/bin/bash

# avoid downloading url, nfo, txt and jpg files

transmission-remote --list |
    grep -vE 'Seeding|100%' |
    sed -e '1d;$d;s/^ *//' |
    cut --only-delimited --delimiter=' ' --fields=1 |
    grep -oE '[0-9]{1,3}' |
    while read -r TORRENT_ID; do
        transmission-remote -t "$TORRENT_ID" -f |
            grep -v '100%' |
            grep -E ".jpg$|.nfo$|.txt$|.url$" |
            awk -F: '{print $1}' |
            while read -r FILE_ID; do
                tranmission-remote -t "$TORRENT_ID" --no-get "$FILE_ID"
            done
    done

