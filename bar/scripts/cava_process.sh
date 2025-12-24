#!/bin/bash

cava -p ~/.config/eww/bar/scripts/cava.conf | while read -r line; do
    bars=""
    for val in $line; do
        case $val in
            0) bars+="▁" ;;
            1) bars+="▂" ;;
            2) bars+="▃" ;;
            3) bars+="▄" ;;
            4) bars+="▅" ;;
            5) bars+="▆" ;;
            6) bars+="▇" ;;
            7) bars+="█" ;;
            *) bars+="▁" ;;
        esac
    done
    echo "$bars"
done
