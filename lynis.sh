#!/bin/sh

[ -z "$1" ] && echo "Usage: $(basename "$0") rcpto@example.com" && exit 1

OUTFILE=$(mktemp)
/usr/bin/nice -n 0 /usr/sbin/lynis --cronjob --auditor "$(hostname -f)" > "$OUTFILE"

[ ! -s "$OUTFILE" ] && exit 2

SUBJECT="[lynis] $(hostname -f) report"
mail -s "$SUBJECT" "$1" < "$OUTFILE"

rm -f "$OUTFILE"

