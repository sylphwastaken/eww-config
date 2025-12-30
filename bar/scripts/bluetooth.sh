#!/bin/bash
if ! systemctl is-active --quiet bluetooth; then
    echo "Off"
    exit 0
fi

powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
if [ "$powered" != "yes" ]; then
    echo "Off"
    exit 0
fi

connected=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)
if [ -n "$connected" ]; then
    echo "$connected"
else
    echo "On"
fi
