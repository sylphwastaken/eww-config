#!/bin/bash
while true; do
    h=$(date +%I)
    m=$(date +%M)
    s=$(date +%S)
    
    # Calculate angles (0 = 12 o'clock, clockwise)
    sec_angle=$((s * 6))
    min_angle=$((m * 6 + s / 10))
    hour_angle=$((h * 30 + m / 2))
    
    echo "{\"hour\":$hour_angle,\"minute\":$min_angle,\"second\":$sec_angle}"
    sleep 1
done
