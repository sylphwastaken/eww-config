#!/bin/bash

cava -p <(cat <<CONF
[general]
framerate = 30
bars = 12

[input]
method = pulse

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7

[smoothing]
integral = 77
monstercat = 1
waves = 0
gravity = 100
CONF
) 2>/dev/null | while IFS= read -r line; do
    bars=""
    IFS=';' read -ra heights <<< "$line"
    for height in "${heights[@]}"; do
        case $height in
            0) bars+="▁";;
            1) bars+="▂";;
            2) bars+="▃";;
            3) bars+="▄";;
            4) bars+="▅";;
            5) bars+="▆";;
            6) bars+="▇";;
            *) bars+="█";;
        esac
    done
    echo "$bars"
done
