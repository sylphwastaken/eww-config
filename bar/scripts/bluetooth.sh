#!/bin/bash
if systemctl is-active --quiet bluetooth; then
    connected=$(bluetoothctl devices Connected | wc -l)
    if [ "$connected" -gt 0 ]; then
        device=$(bluetoothctl devices Connected | head -1 | cut -d' ' -f3-)
        echo "$device"
    else
        echo "On"
    fi
else
    echo "Off"
fi
