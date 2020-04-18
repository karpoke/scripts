#!/bin/sh

# to restore:
#   sudo rsync -axHAXv /media/usb5/rpi-backup/ /

BACKUPDIR="/media/usb5"
PREFIX="rpi-backup"
RSYNCDIR="$BACKUPDIR/$PREFIX"
LOGFILE="$BACKUPDIR/$PREFIX.log"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: You must be root user to run this program"
    exit 1
fi

if [ ! -d "$RSYNCDIR" ]; then
    echo "ERROR: Directory '$RSYNCDIR' not found"
    exit 1
fi

echo "### start: $(date --iso-8601=seconds)" >> $LOGFILE

# sync
#        -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
#        -r, --recursive             recurse into directories
#        -l, --links                 copy symlinks as symlinks
#        -p, --perms                 preserve permissions
#        -t, --times                 preserve modification times
#        -g, --group                 preserve group
#        -o, --owner                 preserve owner (super-user only)
#        -D                          same as --devices --specials
#            --devices               preserve device files (super-user only)
#            --specials              preserve special files
#        -A, --acls                  preserve ACLs (implies -p)
#        -H, --hard-links            preserve hard links
#        -X, --xattrs                preserve extended attributes
#        -v, --verbose               increase verbosity
#        -x, --one-file-system       don't cross filesystem boundaries

time /usr/bin/rsync \
    -axHAXv \
    --delete-during \
    --delete-excluded \
    --exclude-from=/root/rpi-sync-exclude.txt \
    / "$RSYNCDIR" >> $LOGFILE

echo "### end: $(date --iso-8601=seconds)" >> $LOGFILE

