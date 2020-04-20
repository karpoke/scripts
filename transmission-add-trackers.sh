#!/bin/bash

# https://github.com/Entware/Entware/wiki/Using-Transmission

# "script-torrent-added-enabled": true,
# "script-torrent-added-filename": "/opt/etc/transmission/tr_add_trackers.sh",

IDLIST="/tmp/id.list"
TRACKERLIST="/tmp/trackers.list"

get_trackers_list () {
    curl -s -# https://newtrackon.com/api/stable -o $TRACKERLIST
    sed -i '/^$/d' $TRACKERLIST
}

get_torrent_name () {
    TORRENT_ID=$1
    TORRENT_NAME=$(transmission-remote --torrent "$TORRENT_ID" --info | grep Name | awk '{ print $2 }')
    echo "$TORRENT_NAME"
}

add_trackers () {
    TORRENT_ID=$1
    TORRENT_NAME=$(get_torrent_name "$TORRENT_ID")
    while read -r TRACKER; do
        transmission-remote --torrent "$TORRENT_ID" --tracker-add "$TRACKER" >/dev/null
        # logger -t "$(basename "$0")" "Adding $TRACKER to $TORRENT_NAME"
    done < "$TRACKERLIST"
}

check_name () {
    TORRENT_ID=$1
    TORRENT_NAME=$(get_torrent_name "$TORRENT_ID")
    NUM_TRACKERS="$(wc -l < $TRACKERLIST)"
    logger -t "$(basename "$0")" "Updated $TORRENT_NAME with $NUM_TRACKERS additional trackers"

}

add_trackers_to_torrents () {
    transmission-remote --list | grep -vE 'Seeding|Stopped|100%' | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=' ' --fields=1 | grep -oE '[0-9]{1,3}' > $IDLIST
    while read -r TORRENT_ID; do
        add_trackers "$TORRENT_ID"
        check_name "$TORRENT_ID"
    done < "$IDLIST"
}

cleanup () {
    rm -f $TRACKERLIST $IDLIST
}

get_trackers_list
add_trackers_to_torrents
cleanup

