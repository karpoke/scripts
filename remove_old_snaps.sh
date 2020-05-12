#!/bin/sh
# https://superuser.com/a/1330590

# to set the maximum number of snap's versions to 2:
# $ sudo snap set system refresh.retain=2

# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
    while read -r snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done

