#!/bin/bash

# https://trac.transmissionbt.com/wiki/Scripts
# https://trac.transmissionbt.com/browser/trunk/extras/send-email-when-torrent-done.sh

# TR_APP_VERSION
# TR_TIME_LOCALTIME
# TR_TORRENT_DIR
# TR_TORRENT_HASH
# TR_TORRENT_ID
# TR_TORRENT_NAME

./notify-by-telegram.sh """
Torrent downloaded: $TR_TORRENT_NAME
Local time: $TR_TIME_LOCALTIME
"""

# other actions

# download subtitles
# /usr/local/bin/flexget -c .flexget/config.yml execute --tasks subtitles-periscope

