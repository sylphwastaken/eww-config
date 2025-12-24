#!/bin/bash
get_workspaces() {
    active_ws=$(hyprctl activeworkspace -j | jq -r '.id')
    all_ws=$(hyprctl workspaces -j | jq -c '[.[].id] | sort | unique')
    echo "$all_ws" | jq -c --arg active "$active_ws" 'map({id: ., active: (. == ($active | tonumber))})'
}

get_workspaces

# Find the correct socket
SOCKET=$(find /tmp/hypr -name ".socket2.sock" 2>/dev/null | head -1)

if [ -n "$SOCKET" ]; then
    socat -u UNIX-CONNECT:"$SOCKET" - | while read -r line; do
        get_workspaces
    done
fi
