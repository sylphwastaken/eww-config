#!/bin/bash
ws1=$1
ws2=$((ws1 + 1))

# Get current mouse position
eval $(xdotool getmouselocation --shell)

# Switch both monitors to their respective workspaces
hyprctl dispatch workspace $ws1  # Monitor 0 (odd workspace)
hyprctl dispatch focusmonitor 1
hyprctl dispatch workspace $ws2  # Monitor 1 (even workspace)
hyprctl dispatch focusmonitor 0

# Restore mouse position
xdotool mousemove $X $Y
