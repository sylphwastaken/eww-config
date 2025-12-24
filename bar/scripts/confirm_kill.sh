#!/bin/bash
name=$1
pids=$2

# Show confirmation using notify-send with actions (if supported) or zenity
if command -v zenity &> /dev/null; then
    zenity --question --title="Kill Process" --text="Kill $name?\nPIDs: $pids" --width=300
    if [ $? -eq 0 ]; then
        IFS=',' read -ra PID_ARRAY <<< "$pids"
        for pid in "${PID_ARRAY[@]}"; do
            kill -9 "$pid" 2>/dev/null
        done
        notify-send "Process Killed" "$name (PIDs: $pids)"
    fi
else
    # Fallback to simple notification
    notify-send "Kill Process?" "Right-click again to confirm killing $name"
fi
