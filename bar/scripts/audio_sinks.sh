#!/bin/bash
default_sink=$(wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep "id:" | awk '{print $2}' | tr -d ',')

result=$(wpctl status | grep -A 20 "Sinks:" | grep -v "Monitors:" | grep -E "^\s+[│├└]*\s*[0-9]+" | while read line; do
    # Skip if line contains [vol: or other monitor indicators
    if echo "$line" | grep -q "\[vol:"; then
        continue
    fi
    
    id=$(echo "$line" | grep -oP '\d+' | head -1)
    full_line=$(echo "$line" | sed 's/^.*\. //')
    
    # Only include devices that don't have "Monitor" in the name and are available (no asterisk means unavailable)
    if echo "$full_line" | grep -iq "monitor"; then
        continue
    fi
    
    name=$(echo "$full_line" | sed 's/ \[.*$//' | xargs)
    
    if [ -n "$id" ] && [ -n "$name" ]; then
        if [ "$id" = "$default_sink" ]; then
            active="true"
        else
            active="false"
        fi
        
        echo "{\"id\":\"$id\",\"name\":\"$name\",\"active\":$active}"
    fi
done | jq -s '.')

if [ -z "$result" ] || [ "$result" = "null" ]; then
    echo "[]"
else
    echo "$result"
fi
