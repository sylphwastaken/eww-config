#!/bin/bash
art_url=$(playerctl metadata mpris:artUrl 2>/dev/null)
if [ -n "$art_url" ]; then
    # Convert file:// URL to path
    art_path="${art_url#file://}"
    if [ -f "$art_path" ]; then
        echo "$art_path"
    else
        echo ""
    fi
else
    echo ""
fi
