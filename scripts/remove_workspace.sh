#!/bin/bash
ws_count=$(hyprctl workspaces -j | jq 'length')
if [ "$ws_count" -gt 3 ]; then
    max_ws=$(hyprctl workspaces -j | jq '[.[].id] | max')
    hyprctl dispatch workspace $((max_ws - 1))
fi
