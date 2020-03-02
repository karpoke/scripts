#!/bin/bash
# https://github.com/python-telegram-bot/python-telegram-bot/wiki/Performance-Optimizations#server-location

CREDSFILE="$HOME/.tg_auth"

usage () {
    echo "ERROR: $CREDSFILE must contain:"
    echo ""
    echo "TOKEN=550e8400-e29b-41d4-a716-446655440000"
    echo "ID=123456"
}

if [ ! -r "$CREDSFILE" ]; then
    usage
    exit 1
fi

# shellcheck disable=SC1090
source "$CREDSFILE"

if [ -z "$TOKEN" ] || [ -z "$ID" ]; then
    usage
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "$0 <message>"
    exit 1
fi

API_URL="https://api.telegram.org/bot$TOKEN/sendMessage"

/usr/bin/curl \
    -s \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\": \"$ID\", \"text\": \"$*\", \"disable_notification\": true}" \
    -o /dev/null \
    "$API_URL"
