#!/bin/sh

# http://zzzscore.com/1to50/en/result/#!v=U2FsdGVkX18KIBpeCrPiZQN59U8%3D

# make number images the same size 60x60
# for i in {1..50}; do convert $i.png -crop "60x60" $i.png; done
# rename -f 's/-0.png/.png/' *-0.png
# rm *-{1..3}.png

# set -x

get_coords () {
    T=${3-0}
    COORDS=$(visgrep -t "$T" "$1" "$2" | awk '{print $1}')
    X=$(echo "$COORDS" | awk -F, '{print $1}')
    Y=$(echo "$COORDS" | awk -F, '{print $2}')
}

click_image () {
    set -x
    get_coords table.png "$1"

    if [ -z "$X" ]; then
        echo "$i not found. trying harder..."
        get_coords table.png "$1" 10000
    fi
    [ -z "$X" ] && echo "$i not found" && exit 1
    xdotool mousemove "$((OFFSET_X + X + 15))" "$((OFFSET_Y + Y + 15))"
    xdotool click --delay 0 1  # left button
}

get_first_table () {
    scrot screen.png

    get_coords screen.png detect.png 10000
    OFFSET_X=$((X-30))
    OFFSET_Y=$Y
    convert screen.png -crop "420x580+${OFFSET_X}+${OFFSET_Y}" table.png
}

get_second_table () {
    scrot -d 1.5 screen.png
    convert screen.png -crop "420x580+${OFFSET_X}+${OFFSET_Y}" table.png
}

v1 () {
    # visual grep each number
    get_first_table

    for i in $(seq 1 1 25); do
        click_image  "$i.png"
    done

    get_second_table

    for i in $(seq 26 1 50); do
        click_image  "$i.png"
    done
}

v2 () {
    # brute force each number
    get_first_table

    for _ in $(seq 1 1 50); do
        for i in $(seq 0 1 4); do
            for j in $(seq 0 1 4); do
                TX=$((OFFSET_X + i*85))
                TY=$((OFFSET_Y + j*85 + 185))
                xdotool mousemove "$TX" "$TY"
                xdotool click --delay 0 1  # left button
            done
        done
    done
}

main () {
    v2
}
main

