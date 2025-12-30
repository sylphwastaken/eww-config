#!/bin/bash
ws1=$1
ws2=$((ws1 + 1))

eval $(xdotool getmouselocation --shell)

# Switch monitor 0 to odd workspace
hyprctl dispatch focusmonitor 0
hyprctl dispatch workspace $ws1

# Switch monitor 1 to even workspace
hyprctl dispatch focusmonitor 1
hyprctl dispatch workspace $ws2

# Return focus to monitor 0
hyprctl dispatch focusmonitor 0

xdotool mousemove $X $Y
