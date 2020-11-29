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
WORKON_HOME="$HOME/.virtualenvs"

if [ ! -x "$NOTIFY_SCRIPT" ]; then
    logger -t "$(basename "$0")" "Error: cannot run '$NOTIFY_SCRIPT'"
    exit
fi

$NOTIFY_SCRIPT "Downloaded: $TR_TORRENT_NAME"

# other actions

download_subtitles () {
    if [ -n "$(find "$TR_TORRENT_DIR/$TR_TORRENT_NAME" -name \*.avi -o -name \*.mkv -o -name \*.mpg -o -name \*.mpeg -o -name \*.mp4)" ]; then
        logger -t "$(basename "$0")" "Looking for subtitles for $TR_TORRENT_NAME"

        # shellcheck disable=SC1090
        . "$WORKON_HOME/flexget/bin/activate" && flexget --cron execute --task get-subtitles
        deactivate

        # it should only be one
        SUBTITLEFILE=$(find "$TR_TORRENT_DIR/$TR_TORRENT_NAME" -name \*.srt | head -1)
        if [ -n "$SUBTITLEFILE" ]; then
            $NOTIFY_SCRIPT "$SUBTITLEFILE" "Subtitles for $TR_TORRENT_NAME"
        fi
    fi
}

download_subtitles

# move downloaded torrent
# transmission-remote --torrent "$TR_TORRENT_ID" --move <dir>

