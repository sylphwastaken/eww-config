#!/bin/bash
ws_count=$(hyprctl workspaces -j | jq 'length')

if [ "$ws_count" -gt 6 ]; then
    # Get current mouse position
    eval $(xdotool getmouselocation --shell)
    
    max_ws=$(hyprctl workspaces -j | jq '[.[].id] | max')
    
    # Go to previous pair
    prev_ws1=$((max_ws - 3))
    prev_ws2=$((max_ws - 2))
    
    hyprctl dispatch workspace $prev_ws1
    hyprctl dispatch focusmonitor 1
    hyprctl dispatch workspace $prev_ws2
    hyprctl dispatch focusmonitor 0
    
    # Restore mouse position
    xdotool mousemove $X $Y
fi
