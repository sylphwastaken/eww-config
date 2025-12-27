#!/bin/bash

# Find active interface
interface=$(ip route | grep '^default' | awk '{print $5}' | head -1)

if [ -z "$interface" ]; then
    echo '{"type":"disconnected","name":"No Connection","down":"0","up":"0","icon":""}'
    exit 0
fi

# Check if wifi or ethernet
if [[ "$interface" == wl* ]]; then
    type="wifi"
    icon="󰖩"
    name=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
    if [ -z "$name" ]; then
        name="WiFi"
    fi
else
    type="ethernet"
    icon=""
    name="Ethernet"
fi

# Get speeds
rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)
sleep 1
rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)

rx_speed=$(( (rx2 - rx1) / 1024 ))
tx_speed=$(( (tx2 - tx1) / 1024 ))

echo "{\"type\":\"$type\",\"name\":\"$name\",\"down\":\"${rx_speed}KB/s\",\"up\":\"${tx_speed}KB/s\",\"icon\":\"$icon\"}"
