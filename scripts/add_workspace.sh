#!/bin/bash
max_ws=$(hyprctl workspaces -j | jq '[.[].id] | max')
new_ws=$((max_ws + 1))
hyprctl dispatch workspace $new_ws
