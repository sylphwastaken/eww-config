#!/bin/bash
powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
if [ "$powered" = "yes" ]; then
    bluetoothctl power off
    notify-send "Bluetooth" "Turned off"
else
    bluetoothctl power on
    notify-send "Bluetooth" "Turned on"
fi
