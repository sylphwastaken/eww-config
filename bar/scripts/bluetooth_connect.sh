#!/bin/bash
mac=$1
connected=$(bluetoothctl info "$mac" 2>/dev/null | grep "Connected:" | awk '{print $2}')
if [ "$connected" = "yes" ]; then
    bluetoothctl disconnect "$mac"
else
    bluetoothctl connect "$mac"
fi
