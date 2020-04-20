#!/bin/bash

CREDSFILE="$HOME/.mail_auth"

err () {
    echo "ERROR: $CREDSFILE must contain:"
    echo ""
    echo "USERNAME=name@example.com"
    echo "PASSWD=p4ssw0rd"
    echo "SMTPSERVER=smpts://smtp.example.com:465"
    echo "MAILFROM=name@example.com"
    echo "MAILRCPT=rcpt@example.com"
}

if [ ! -r "$CREDSFILE" ]; then
    err
    exit 1
fi

# shellcheck disable=SC1090
. "$CREDSFILE"

if [ -z "$USERNAME" ] || [ -z "$PASSWD" ] || [ -z "$SMTPSERVER" ] || [ -z "$MAILFROM" ] || [ -z "$MAILRCPT" ]; then
    err
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "Usage: echo 'Message' | $0 subject"
    exit 1
fi

FILE=$(mktemp "$0.$$.XXXX")

/bin/cat << EOF > "$FILE"
From: $MAILFROM
To: $MAILRCPT
Subject: $*

EOF

while read -r LINE; do
    echo "$LINE" >> "$FILE"
done

/usr/bin/curl \
    -s \
    -u "$USERNAME:$PASSWD" \
    "$SMTPSERVER" \
    --mail-from "$MAILFROM" \
    --mail-rcpt "$MAILRCPT" \
    --upload-file "$FILE"

/bin/rm "$FILE"

