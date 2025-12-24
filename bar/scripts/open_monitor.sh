#!/bin/bash

# Close all monitors first
eww close cpu-monitor 2>/dev/null
eww close gpu-monitor 2>/dev/null
eww close ram-monitor 2>/dev/null
eww close power-menu 2>/dev/null
eww close audio-controls 2>/dev/null

# Open the requested monitor
case $1 in
    cpu)
        eww open cpu-monitor
        ;;
    gpu)
        eww open gpu-monitor
        ;;
    ram)
        eww open ram-monitor
        ;;
    power)
        eww open power-menu
        ;;
    audio)
        eww open audio-controls
        ;;
esac
