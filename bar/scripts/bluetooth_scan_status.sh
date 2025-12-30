#!/bin/bash
SCAN_FILE="/tmp/bt_scan_remaining"
if [ -f "$SCAN_FILE" ]; then
    remaining=$(cat "$SCAN_FILE")
    echo "{\"scanning\":true,\"remaining\":$remaining}"
else
    echo "{\"scanning\":false,\"remaining\":0}"
fi
