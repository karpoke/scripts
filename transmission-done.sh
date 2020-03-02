#!/bin/bash

# https://trac.transmissionbt.com/wiki/Scripts
# https://trac.transmissionbt.com/browser/trunk/extras/send-email-when-torrent-done.sh

# TR_APP_VERSION
# TR_TIME_LOCALTIME
# TR_TORRENT_DIR
# TR_TORRENT_HASH
# TR_TORRENT_ID
# TR_TORRENT_NAME

THIS_DIR="$(readlink -f "${BASH_SOURCE%/*}")"
NOTIFY_SCRIPT="${THIS_DIR}/notify-by-telegram.sh"

if [ ! -x "$NOTIFY_SCRIPT" ]; then
    echo "Error: cannot run '$NOTIFY_SCRIPT'"
    exit
fi

$NOTIFY_SCRIPT "Downloaded: $TR_TORRENT_NAME"

# other actions

# download subtitles
# /usr/local/bin/flexget -c .flexget/config.yml execute --tasks subtitles-periscope

# move downloaded torrent
# transmission-remote --torrent "$TR_TORRENT_ID" --move <dir>

