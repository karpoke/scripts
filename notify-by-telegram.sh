#!/bin/bash
# https://github.com/python-telegram-bot/python-telegram-bot/wiki/Performance-Optimizations#server-location

# Credentials file: ~/.tg_auth
# $ cat ~/.tg_auth
# TOKEN=550e8400-e29b-41d4-a716-446655440000
# ID=123456

get_credentials () {
    CREDSFILE="$HOME/.tg_auth"

    if [ ! -r "$CREDSFILE" ]; then
        logger -t "$(basename "$0")" "Credentials file not found"
        exit 2
    fi

    # shellcheck disable=SC1090
    # change this for: grep -cx TOKEN=(.*)
    . "$CREDSFILE"

    if [ -z "$TOKEN" ] || [ -z "$ID" ]; then
        logger -t "$(basename "$0")" "Credentials not valid"
        exit 3
    fi
}

get_file_endpoint () {
    if file "$1" | grep -qiE 'image|bitmap'; then
        ENDPOINT="sendPhoto"
    elif file "$1" | grep -qi 'audio'; then
        ENDPOINT="sendAudio"
    else
        ENDPOINT="sendDocument"
    fi
    echo $ENDPOINT
}

get_endpoint () {
    if test -r "$1"; then
        ENDPOINT=$(get_file_endpoint "$1")
    else
        ENDPOINT="sendMessage"
    fi

    API_URL="https://api.telegram.org/bot$TOKEN/$ENDPOINT"
    echo "$API_URL"
}

get_file_data () {
    DATA=""
    if test -r "$1"; then
        REAL_PATH="$(readlink -f "$1")"
        if file "$1" | grep -qiE 'image|bitmap'; then
            FIELD="photo"
        elif file "$1" | grep -qi 'audio'; then
            FIELD="audio"
        else
            FIELD="document"
        fi
        DATA="$FIELD=@\"$REAL_PATH\""
    fi
    echo "$DATA"
}

main () {
    if [ "$#" -eq 0 ]; then
        echo "$(basename "$0") [<file>] <message>"
        exit 1
    fi

    get_credentials

    ENDPOINT="$(get_endpoint "$1")"
    FILEDATA="$(get_file_data "$@")"

    if [ -n "$FILEDATA" ]; then
        shift
        /usr/bin/curl "$ENDPOINT" -s -o /dev/null \
            -F "chat_id=$ID" \
            -F "caption=$*" \
            -F "$FILEDATA"
   else
        /usr/bin/curl "$ENDPOINT" -s -o /dev/null \
            -d "chat_id=$ID" \
            -d "text=$*"
   fi
}

main "$@"

