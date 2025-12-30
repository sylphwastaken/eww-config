#!/bin/bash
current=$(cat /tmp/eww_ws_count 2>/dev/null || echo 3)

if [ "$current" -gt 3 ]; then
    eval $(xdotool getmouselocation --shell)
    
    # Calculate workspaces being removed
    remove_ws1=$(( (current - 1) * 2 + 1 ))
    remove_ws2=$(( remove_ws1 + 1 ))
    
    # Calculate destination workspaces (previous pair)
    new_count=$((current - 1))
    dest_ws1=$(( (new_count - 1) * 2 + 1 ))
    dest_ws2=$(( dest_ws1 + 1 ))
    
    # Move all windows from workspace being removed to previous pair
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $remove_ws1) | .address" | while read addr; do
        hyprctl dispatch movetoworkspacesilent "$dest_ws1,address:$addr"
    done
    
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $remove_ws2) | .address" | while read addr; do
        hyprctl dispatch movetoworkspacesilent "$dest_ws2,address:$addr"
    done
    
    # Update count
    echo "$new_count" > /tmp/eww_ws_count
    
    # Switch to previous pair
    hyprctl dispatch focusmonitor 0
    hyprctl dispatch workspace $dest_ws1
    
    hyprctl dispatch focusmonitor 1
    hyprctl dispatch workspace $dest_ws2
    
    hyprctl dispatch focusmonitor 0
    
    xdotool mousemove $X $Y
fi
