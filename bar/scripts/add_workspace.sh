#!/bin/bash
# Get current mouse position
eval $(xdotool getmouselocation --shell)

max_ws=$(hyprctl workspaces -j | jq '[.[].id] | max')
new_ws1=$((max_ws + 1))
new_ws2=$((max_ws + 2))

# Create and switch to new workspace pair
hyprctl dispatch workspace $new_ws1
hyprctl dispatch focusmonitor 1
hyprctl dispatch workspace $new_ws2
hyprctl dispatch focusmonitor 0

# Restore mouse position
xdotool mousemove $X $Y
