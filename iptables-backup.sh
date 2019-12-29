#!/bin/bash

# to restore:
#  /sbin/iptables-restore < /etc/iptables/iptables-rules.2019-12-17

DAYSOLDER=30

BACKUPDIR="/etc/iptables"
PREFIX="iptables-rules"
BACKUPFILE="$PREFIX.$(date +%F)"
ZIPFILE="$BACKUPDIR/$BACKUPFILE.zip"

/bin/mkdir -p "$BACKUPDIR"

/sbin/iptables-save | /usr/bin/zip > "$ZIPFILE"
echo -e "@ -\n@=$BACKUPFILE" | /usr/bin/zipnote -w "$ZIPFILE"

# delete old backups
/usr/bin/find "$BACKUPDIR" -name "$PREFIX*.zip" -mtime +"$DAYSOLDER" -delete
