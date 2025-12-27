#!/bin/bash

players=$(playerctl -l 2>/dev/null)

if [ -z "$players" ]; then
    echo "[]"
    exit 0
fi

echo "["
first=true
while IFS= read -r player; do
    title=$(playerctl -p "$player" metadata title 2>/dev/null || echo "Unknown")
    artist=$(playerctl -p "$player" metadata artist 2>/dev/null || echo "Unknown Artist")
    status=$(playerctl -p "$player" status 2>/dev/null || echo "Paused")
    
    # Position is in seconds as float
    position=$(playerctl -p "$player" position 2>/dev/null | awk '{printf "%d", int($1)}' || echo "0")
    
    # Length is in microseconds, convert to seconds
    length=$(playerctl -p "$player" metadata mpris:length 2>/dev/null | awk '{printf "%d", int($1/1000000)}' || echo "100")
    
    art_url=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null || echo "")
    
    # Convert file:// to path
    art_path="${art_url#file://}"
    if [ ! -f "$art_path" ]; then
        art_path=""
    fi
    
    # Calculate time displays
    pos_min=$(echo "$position" | awk '{printf "%d", int($1/60)}')
    pos_sec=$(echo "$position" | awk '{printf "%02d", int($1)%60}')
    len_min=$(echo "$length" | awk '{printf "%d", int($1/60)}')
    len_sec=$(echo "$length" | awk '{printf "%02d", int($1)%60}')
    
    if [ "$first" = false ]; then
        echo ","
    fi
    first=false
    
    cat << JSON
{
  "player": "$player",
  "title": "$title",
  "artist": "$artist",
  "status": "$status",
  "position": $position,
  "length": $length,
  "art": "$art_path",
  "pos_display": "$pos_min:$pos_sec",
  "len_display": "$len_min:$len_sec"
}
JSON
done <<< "$players"

echo "]"
