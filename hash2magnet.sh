#!/bin/bash

HASH="$1"

if [ "${#HASH}" != 40 ]; then
    echo "Error: not a valid hash"
    exit
fi

shift
NAME="&dn=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$*")"

TRACKERS="\
&tr=http://re-tracker.uz:80/announce\
&tr=https://1.tracker.eu.org:443/announce\
&tr=https://3.tracker.eu.org:443/announce\
&tr=https://tracker.parrotsec.org:443/announce\
&tr=http://tracker2.dler.org:80/announce\
&tr=http://tracker3.itzmx.com:6961/announce\
&tr=http://tracker.gbitt.info:80/announce\
&tr=http://tracker.openzim.org:80/announce\
&tr=http://tracker.tfile.me/announce\
&tr=http://vps02.net.orel.ru:80/announce\
&tr=udp://explodie.org:6969/announce\
&tr=udp://open.demonii.com:1337/announce\
&tr=udp://retracker.netbynet.ru:2710/announce\
&tr=udp://tracker.cyberia.is:6969/announce\
&tr=udp://tracker.filemail.com:6969/announce\
&tr=udp://tracker.moeking.me:6969/announce\
&tr=udp://tracker.nyaa.uk:6969/announce\
&tr=udp://tracker.openbittorrent.com:80\
&tr=udp://tracker.opentrackr.org:1337/announce\
&tr=udp://tracker.port443.xyz:6969/announce\
&tr=udp://tracker.publicbt.com:80\
&tr=udp://tracker.skynetcloud.tk:6969/announce\
"

MAGNET="magnet:?xt=urn:btih:${HASH}${NAME}${TRACKERS}"
transmission-remote --add "$MAGNET"

