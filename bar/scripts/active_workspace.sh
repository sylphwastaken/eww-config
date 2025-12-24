#!/bin/bash
get_active() {
    hyprctl activeworkspace -j | jq -r '.id'
}

get_active

# Listen to Hyprland workspace events
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    case $line in
        workspace*)
            get_active
            ;;
    esac
done
