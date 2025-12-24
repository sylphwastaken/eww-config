#!/bin/bash

# Get the active connection type and interface
active_conn=$(nmcli -t -f TYPE,DEVICE,STATE connection show --active | grep ":connected" | head -1)
conn_type=$(echo "$active_conn" | cut -d: -f1)
interface=$(echo "$active_conn" | cut -d: -f2)

# If no interface found, try to find default route interface
if [ -z "$interface" ]; then
    interface=$(ip route | grep default | awk '{print $5}' | head -1)
fi

# Determine icon based on connection type or interface name
if [[ "$conn_type" == *"ethernet"* ]] || [[ "$interface" == "eth"* ]] || [[ "$interface" == "en"* ]]; then
    icon="󰈀"
    name="Ethernet"
elif [[ "$conn_type" == *"wireless"* ]] || [[ "$conn_type" == *"wifi"* ]] || [[ "$interface" == "wl"* ]]; then
    icon="󰖩"
    name=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
    [ -z "$name" ] && name="WiFi"
else
    icon="󰌙"
    name="Disconnected"
    echo "{\"icon\":\"$icon\",\"name\":\"$name\",\"down\":\"0K\",\"up\":\"0K\"}"
    exit 0
fi

# Get network speeds
if [ -n "$interface" ] && [ -e "/sys/class/net/$interface/statistics/rx_bytes" ]; then
    # Read initial values
    rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    
    sleep 1
    
    # Read values after 1 second
    rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    
    # Calculate speeds in bytes per second
    rx_speed=$(( rx2 - rx1 ))
    tx_speed=$(( tx2 - tx1 ))
    
    # Format speeds
    if [ $rx_speed -gt 1048576 ]; then
        down=$(printf "%.1fM" $(echo "scale=1; $rx_speed/1048576" | bc))
    elif [ $rx_speed -gt 1024 ]; then
        down=$(printf "%.0fK" $(echo "$rx_speed/1024" | bc))
    else
        down="${rx_speed}B"
    fi
    
    if [ $tx_speed -gt 1048576 ]; then
        up=$(printf "%.1fM" $(echo "scale=1; $tx_speed/1048576" | bc))
    elif [ $tx_speed -gt 1024 ]; then
        up=$(printf "%.0fK" $(echo "$tx_speed/1024" | bc))
    else
        up="${tx_speed}B"
    fi
else
    down="N/A"
    up="N/A"
fi

echo "{\"icon\":\"$icon\",\"name\":\"$name\",\"down\":\"$down\",\"up\":\"$up\"}"
