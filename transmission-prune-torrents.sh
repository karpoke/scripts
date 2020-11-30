#!/bin/bash

# avoid downloading url, nfo, txt and jpg files

get_torrent_name () {
    TORRENT_ID=$1
    TORRENT_NAME=$(transmission-remote --torrent "$TORRENT_ID" --info | grep Name | cut -c9-)
    echo "$TORRENT_NAME"
}

get_torrent_file_name () {
    TORRENT_ID=$1
    FILE_ID=$2
    TORRENT_NAME=$(transmission-remote --torrent "$TORRENT_ID" --info-files | grep "$FILE_ID:" | awk '{for(i=7;i<=NF;++i)printf $i""FS ; print ""}')
    echo "$TORRENT_NAME"
}


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
                transmission-remote -t "$TORRENT_ID" --no-get "$FILE_ID"
                TORRENT_NAME=$(get_torrent_name "$TORRENT_ID")
                FILE_NAME=$(get_torrent_file_name "$TORRENT_ID" "$FILE_ID")
                logger -t "$(basename "$0")" "Torrent: $TORRENT_NAME Discard file: $FILE_NAME"
            done
    done

