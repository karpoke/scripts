#!/bin/bash

# https://wiki.videolan.org/Documentation:Modules/screen/

mapfile -t SCREENS < <(xrandr -q | grep -w connected)

printf "%s\n" "${SCREENS[@]}" | nl -v 0

read -rp "Screen? " option

[ "$option" -ge 0 ] && [ "$option" -lt "${#SCREENS[@]}" ] || exit 1

if [[ "${SCREENS[$option]}" =~ ([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+) ]]; then
    WIDTH=${BASH_REMATCH[1]}
    HEIGHT=${BASH_REMATCH[2]}
    LEFT=${BASH_REMATCH[3]}
    TOP=${BASH_REMATCH[4]}
fi

# run `vlc -H` for options for your version

# :screen-mouse-image=file:///~/cursorimage.png
# :sout=#transcode{vcodec=h264,vb=0,scale=0,acodec=mpga,ab=128,channels=2,samplerate=44100}:file{dst=~/test.mp4} :sout-keep
# --dshow-fps=29.950001 --nooverlay --sout #transcode{vcodec=h264,vb=800, scale=0.5,acodec=mp3,ab=128,channels=2} :duplicate{dst=std{access=file, mux=mp4,dst=~/test.flv}}

cvlc \
    --no-embedded-video \
    --no-video-deco \
    --screen-fps=30 \
    --screen-width="$WIDTH" \
    --screen-height="$HEIGHT" \
    --screen-left="$LEFT" \
    --screen-top="$TOP" \
    screen://

