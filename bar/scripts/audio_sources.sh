#!/bin/bash

wpctl status | awk '
BEGIN {in_sources=0; in_filters=0}

/Sources:/ {in_sources=1; in_filters=0; next}
/Filters:/ {in_sources=0; in_filters=1; next}
/Streams:/ {in_sources=0; in_filters=0}

# Regular sources section
in_sources && /^\s+[\*│├└─\s]*[0-9]+\./ {
    has_asterisk = ($0 ~ /\*/)
    
    line = $0
    gsub(/[│├└─\*]/, "", line)
    gsub(/^\s+/, "", line)
    
    match(line, /^[0-9]+/)
    id = substr(line, RSTART, RLENGTH)
    
    sub(/^[0-9]+\.\s*/, "", line)
    sub(/\s*\[.*$/, "", line)
    name = line
    
    if (has_asterisk) active = "true"
    else active = "false"
    
    gsub(/"/, "\\\"", name)
    if (name != "") print "{\"id\":\"" id "\",\"name\":\"" name "\",\"active\":" active "}"
}

# Filters section - only [Audio/Source] items
in_filters && /Audio\/Source/ && !/split/ {
    has_asterisk = ($0 ~ /\*/)
    
    line = $0
    gsub(/[│├└─\*]/, "", line)
    gsub(/^\s+/, "", line)
    
    match(line, /^[0-9]+/)
    id = substr(line, RSTART, RLENGTH)
    
    sub(/^[0-9]+\.\s*/, "", line)
    sub(/\s*\[.*$/, "", line)
    name = line
    
    if (has_asterisk) active = "true"
    else active = "false"
    
    gsub(/"/, "\\\"", name)
    if (name != "") print "{\"id\":\"" id "\",\"name\":\"" name "\",\"active\":" active "}"
}
' | jq -s '.'
