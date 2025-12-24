#!/bin/bash
default_source=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep "id:" | awk '{print $2}' | tr -d ',')

result=$(wpctl status | grep -A 40 "Sources:" | grep -v "Monitors:" | grep -E "^\s+[│├└]*\s*[0-9]+" | while read line; do
    id=$(echo "$line" | grep -oP '\d+' | head -1)
    full_line=$(echo "$line" | sed 's/^.*\. //')
    
    # Only include actual input devices, skip monitors
    if echo "$full_line" | grep -iq "monitor"; then
        continue
    fi
    
    name=$(echo "$full_line" | sed 's/ \[.*$//' | xargs)
    
    if [ -n "$id" ] && [ -n "$name" ]; then
        if [ "$id" = "$default_source" ]; then
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
