#!/bin/bash
get_workspaces() {
    hyprctl workspaces -j | jq -c 'map({id: .id, pair: ((.id + 1) / 2 | floor)}) | sort_by(.id)'
}

get_workspaces

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    case $line in
        workspace*|createworkspace*|destroyworkspace*)
            get_workspaces
            ;;
    esac
done
