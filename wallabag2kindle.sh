#!/bin/bash

# https://gist.github.com/petermolnar/988ba2fa2770b71a443e437cd4052aeb

# create client: https://wallabag.example.com/developer
# api methods: https://wallabag.example.com/api/doc
# api doc: https://doc.wallabag.org/en/developer/api/readme.html

[ -n "$DEBUG" ] && set -x

setup () {
    TEMPDIR="${HOME}/.wallabag"
    mkdir -p "${TEMPDIR}"
}

get_credentials () {
    CREDSFILE="$HOME/.wallabag_auth"

    if [ ! -r "$CREDSFILE" ]; then
        logger -t "$(basename "$0")" "Credentials file not found"
        exit 1
    fi

    # shellcheck disable=SC1090
    # change this for: grep -cx TOKEN=(.*)
    . "$CREDSFILE"

    if [ -z "$API_URL" ] || [ -z "$ID" ] || [ -z "$USERNAME" ] || [ -z "$SECRET" ] || [ -z "$PASSWORD" ] || [ -z "$KINDLE_EMAIL" ]; then
        logger -t "$(basename "$0")" "Credentials not valid"
        exit 2
    fi
}

get_access_token () {
    TOKEN="$(curl -s -d "grant_type=password" -d "client_id=${ID}" -d "client_secret=${SECRET}" -d "username=${USERNAME}" -d "password=${PASSWORD}" "${API_URL}/oauth/v2/token")"
    ACCESS_TOKEN="$(echo "${TOKEN}" | jq -r '.access_token')"
}

get_last_entries () {
    LAST_WEEK_TS=$(date --date="now -1week" +%s)
    ENTRIES=$(curl -s -G -H "Authorization:Bearer ${ACCESS_TOKEN}" "${API_URL}/api/entries.pdf?since=${LAST_WEEK_TS}")

    DATE=$(echo "${ENTRIES}" | jq -r '._embedded.items[].created_at' | xargs | head -1 | cut -c-10)
    TITLE="Unread articles since ${DATE}"

    IDS=($(echo "${ENTRIES}" | jq -r '._embedded.items[].id' | xargs))
    URLS=($(echo "${ENTRIES}" | jq -r '._embedded.items[].url' | xargs))

    [ "${#IDS[*]}" -eq 0 ] && exit 3

    # export entries

    for i in "${!IDS[@]}"; do
        ID="${IDS[$i]}"
        FNAME="$(echo "${URLS[$i]}" | sed -r 's#https?://([w]{3}\.)?##' | sed -e 's/[^[:alnum:]]/-/g' | sed -r 's/s(.*)-/\1/' | tr '[:upper:]' '[:lower:]')"
        [ "${FNAME}" == "null" ] && continue
        TARGET="${TEMPDIR}/${ID}_${FNAME}.pdf"
        curl -s -G -H "Authorization:Bearer ${ACCESS_TOKEN}" -o "${TARGET}" "${API_URL}/api/entries/${ID}/export.pdf"
    done
}

combine_entries () {
    # pdftk "${TEMPDIR}"/*.pdf cat output "${TEMPDIR}/${DATE}.pdf"
    # gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dAutoRotatePages=/None -sOutputFile=finished.pdf "${TEMPDIR}"/*.pdf "${TEMPDIR}/${DATE}.pdf"

    if [ "${#IDS[*]}" -gt 1 ]; then
        pdfunite "${TEMPDIR}"/*.pdf "${TEMPDIR}/${DATE}.pdf"
    else
        mv "${TEMPDIR}"/*.pdf "${TEMPDIR}/${DATE}.pdf"
    fi

    for FORMAT in epub mobi; do
        ebook-convert \
            --book-producer "$(basename "$0")" \
            --comments "${TITLE}" \
            --pubdate "${DATE}" \
            --publisher "$USER at $(hostname)" \
            --title "${TITLE}" \
            "${TEMPDIR}/${DATE}.pdf" "${TEMPDIR}/${DATE}.${FORMAT}" >/dev/null
    done
}

send_files () {
    mpack -s "${TITLE}" "${TEMPDIR}/${DATE}.mobi" "${KINDLE_EMAIL}"
    notify-by-telegram.sh "${TEMPDIR}/${DATE}.epub" "${TITLE}"
}

cleanup () {
    [ -z "$DEBUG" ] && rm -fr "${HOME}/.wallabag"
}

main () {
    setup
    get_credentials
    get_access_token
    get_last_entries
    combine_entries
    send_files
    cleanup
}

main

