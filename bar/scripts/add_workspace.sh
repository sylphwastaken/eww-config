#!/bin/bash
eval $(xdotool getmouselocation --shell)

current=$(cat /tmp/eww_ws_count 2>/dev/null || echo 3)
new_count=$((current + 1))
echo "$new_count" > /tmp/eww_ws_count

# Calculate new workspace pair
new_ws1=$(( (new_count - 1) * 2 + 1 ))
new_ws2=$(( new_ws1 + 1 ))

# Create workspace on monitor 0 (odd workspace)
hyprctl dispatch focusmonitor 0
hyprctl dispatch workspace $new_ws1

# Create workspace on monitor 1 (even workspace)
hyprctl dispatch focusmonitor 1
hyprctl dispatch workspace $new_ws2

# Return focus to monitor 0
hyprctl dispatch focusmonitor 0

xdotool mousemove $X $Y
