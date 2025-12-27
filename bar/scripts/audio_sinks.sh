#!/bin/bash

wpctl status | awk '
/Sinks:/ {in_sinks=1; next}
/Sources:/ {in_sinks=0}
in_sinks && /[0-9]+\./ {
    # Check if line has asterisk
    has_asterisk = ($0 ~ /\*/)
    
    # Remove box drawing characters and asterisk
    line = $0
    gsub(/[│├└─]/, "", line)
    gsub(/\*/, "", line)
    gsub(/^\s+/, "", line)
    
    # Now line should be like: "60. iD4 Headphones / Monitor [vol: 0.99]"
    # Extract ID (number before the dot)
    match(line, /^[0-9]+/)
    id = substr(line, RSTART, RLENGTH)
    
    # Remove the ID and dot
    sub(/^[0-9]+\.\s*/, "", line)
    
    # Remove everything from [ onwards (volume info)
    sub(/\s*\[.*$/, "", line)
    
    # Now line should be just the name
    name = line
    
    # Set active status
    if (has_asterisk) {
        active = "true"
    } else {
        active = "false"
    }
    
    # Escape quotes
    gsub(/"/, "\\\"", name)
    
    if (id != "" && name != "") {
        print "{\"id\":\"" id "\",\"name\":\"" name "\",\"active\":" active "}"
    }
}
' | jq -s '.'
