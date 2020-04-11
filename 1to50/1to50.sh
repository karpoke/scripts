#!/bin/sh
# http://zzzscore.com/1to50/en/result/#!v=U2FsdGVkX18KIBpeCrPiZQN59U8%3D

# make number images the same size 60x60
# for i in {1..50}; do convert $i.png -crop "60x60" $i.png; done
# rename -f 's/-0.png/.png/' *-0.png
# rm *-{1..3}.png

# set -x

click_image () {
    COORDS=$(visgrep table.png "$1" | awk '{print $1}')
    # shellcheck disable=SC2039
    X=$(echo "$COORDS" | awk -F, '{print $1}')
    Y=$(echo "$COORDS" | awk -F, '{print $2}')
    if [ -z "$X" ]; then
        echo "$i not found. trying harder..."
        COORDS=$(visgrep -t 10000 table.png "$1" | awk '{print $1}')
        # shellcheck disable=SC2039
        X=$(echo "$COORDS" | awk -F, '{print $1}')
        Y=$(echo "$COORDS" | awk -F, '{print $2}')
    fi
    [ -z "$X" ] && echo "$i not found" && exit 1
    xdotool mousemove "$((OFFSET_X + X + 15))" "$((OFFSET_Y + Y + 15))"
    xdotool click 1  # left button
}

scrot screen.png

COORDS=$(visgrep -t1000 screen.png detect.png | awk '{print $1}')
# shellcheck disable=SC2039
OFFSET_X=$(echo "$COORDS" | awk -F, '{print $1}')
OFFSET_Y=$(echo "$COORDS" | awk -F, '{print $2}')
convert screen.png -crop "420x580+${OFFSET_X}+${OFFSET_Y}" table.png

for i in $(seq 1 1 25); do
    click_image  "$i.png"
done

scrot -d 1.5 screen.png
convert screen.png -crop "420x580+${OFFSET_X}+${OFFSET_Y}" table.png

for i in $(seq 26 1 50); do
    click_image  "$i.png"
done
