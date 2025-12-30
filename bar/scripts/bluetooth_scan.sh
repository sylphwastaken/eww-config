#!/bin/bash

SCAN_FILE="/tmp/bt_scan_remaining"

# Check if bluetooth is powered on
powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
if [ "$powered" != "yes" ]; then
    notify-send "Bluetooth" "Turn on Bluetooth first"
    exit 0
fi

# Check if already scanning
if [ -f "$SCAN_FILE" ]; then
    bluetoothctl scan off 2>/dev/null
    rm -f "$SCAN_FILE"
    notify-send "Bluetooth" "Scan stopped"
    exit 0
fi

# Get devices before scan
before=$(bluetoothctl devices 2>/dev/null | wc -l)

notify-send "Bluetooth" "Scanning for 60 seconds..."

# Start scan
bluetoothctl scan on 2>/dev/null &

# Countdown
for i in $(seq 60 -1 1); do
    echo "$i" > "$SCAN_FILE"
    sleep 1
    [ ! -f "$SCAN_FILE" ] && exit 0
done

# Stop scan
bluetoothctl scan off 2>/dev/null
rm -f "$SCAN_FILE"

# Get devices after scan
after=$(bluetoothctl devices 2>/dev/null | wc -l)
new_devices=$((after - before))

if [ "$new_devices" -gt 0 ]; then
    notify-send "Bluetooth" "Found $new_devices new device(s)"
else
    notify-send "Bluetooth" "No new devices found"
fi
