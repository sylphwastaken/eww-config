#!/bin/bash

# cpu_percent.sh
cat > ~/.config/eww/scripts/cpu_percent.sh << 'EOF'
#!/bin/bash
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d. -f1
EOF

# cpu_speed.sh
cat > ~/.config/eww/scripts/cpu_speed.sh << 'EOF'
#!/bin/bash
grep "cpu MHz" /proc/cpuinfo | head -1 | awk '{printf "%.1fGHz", $4/1000}'
EOF

# gpu_percent.sh
cat > ~/.config/eww/scripts/gpu_percent.sh << 'EOF'
#!/bin/bash
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits
elif command -v radeontop &> /dev/null; then
    radeontop -d - -l 1 | grep -o 'gpu [0-9]*' | awk '{print $2}'
else
    echo "0"
fi
EOF

# gpu_speed.sh
cat > ~/.config/eww/scripts/gpu_speed.sh << 'EOF'
#!/bin/bash
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits | awk '{printf "%.0fMHz", $1}'
else
    echo "N/A"
fi
EOF

# ram_used.sh
cat > ~/.config/eww/scripts/ram_used.sh << 'EOF'
#!/bin/bash
free -h | awk '/^Mem:/ {print $3}'
EOF

# ram_total.sh
cat > ~/.config/eww/scripts/ram_total.sh << 'EOF'
#!/bin/bash
free -h | awk '/^Mem:/ {print $2}'
EOF

# volume.sh
cat > ~/.config/eww/scripts/volume.sh << 'EOF'
#!/bin/bash
wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
EOF

# mic.sh
cat > ~/.config/eww/scripts/mic.sh << 'EOF'
#!/bin/bash
wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100)}'
EOF

# wifi.sh
cat > ~/.config/eww/scripts/wifi.sh << 'EOF'
#!/bin/bash
ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
if [ -z "$ssid" ]; then
    echo "Disconnected"
else
    echo "$ssid"
fi
EOF

# bluetooth.sh
cat > ~/.config/eww/scripts/bluetooth.sh << 'EOF'
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
EOF

# music.sh
cat > ~/.config/eww/scripts/music.sh << 'EOF'
#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    echo "$artist - $title" | cut -c1-40
elif [ "$status" = "Paused" ]; then
    echo "Paused"
else
    echo "No media"
fi
EOF

# workspaces.sh
cat > ~/.config/eww/scripts/workspaces.sh << 'EOF'
#!/bin/bash
hyprctl workspaces -j | jq -c 'map({id: .id, active: false}) | sort_by(.id)'

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    hyprctl workspaces -j | jq -c 'map({id: .id, active: false}) | sort_by(.id)'
done
EOF

# Make all scripts executable
chmod +x ~/.config/eww/scripts/*.sh

echo "All scripts created successfully!"
