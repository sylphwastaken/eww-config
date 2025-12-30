#!/bin/bash

# Check if bluetooth service is running
if ! systemctl is-active --quiet bluetooth; then
    echo "{\"status\":\"off\",\"devices\":[],\"scanning\":false}"
    exit 0
fi

powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
if [ "$powered" = "yes" ]; then
    status="on"
else
    status="off"
    echo "{\"status\":\"off\",\"devices\":[],\"scanning\":false}"
    exit 0
fi

# Check if scanning
scanning=$(bluetoothctl show 2>/dev/null | grep "Discovering:" | awk '{print $2}')
if [ "$scanning" = "yes" ]; then
    scan_state="true"
else
    scan_state="false"
fi

# Get paired devices
devices=$(bluetoothctl devices Paired 2>/dev/null | while read -r _ mac name; do
    if [ -n "$mac" ]; then
        connected=$(bluetoothctl info "$mac" 2>/dev/null | grep "Connected:" | awk '{print $2}')
        if [ "$connected" = "yes" ]; then
            conn="true"
        else
            conn="false"
        fi
        # Escape quotes in name
        name=$(echo "$name" | sed 's/"/\\"/g')
        echo "{\"mac\":\"$mac\",\"name\":\"$name\",\"connected\":$conn,\"paired\":true}"
    fi
done | jq -s '.' 2>/dev/null)

# If no devices, return empty array
if [ -z "$devices" ] || [ "$devices" = "null" ]; then
    devices="[]"
fi

echo "{\"status\":\"$status\",\"devices\":$devices,\"scanning\":$scan_state}"
