#!/bin/bash

# Close all monitors and closers first
eww close cpu-monitor cpu-monitor-closer 2>/dev/null
eww close gpu-monitor gpu-monitor-closer 2>/dev/null
eww close ram-monitor ram-monitor-closer 2>/dev/null
eww close power-menu power-menu-closer 2>/dev/null
eww close audio-controls audio-controls-closer 2>/dev/null
eww close calendar-popup calendar-popup-closer 2>/dev/null
eww close music-widget music-widget-closer 2>/dev/null
eww close weather-popup weather-popup-closer 2>/dev/null
eww close bluetooth-popup bluetooth-popup-closer 2>/dev/null

# Open closer FIRST (background), then popup (foreground)
case $1 in
    cpu)
        eww open cpu-monitor-closer
        eww open cpu-monitor
        ;;
    gpu)
        eww open gpu-monitor-closer
        eww open gpu-monitor
        ;;
    ram)
        eww open ram-monitor-closer
        eww open ram-monitor
        ;;
    power)
        eww open power-menu-closer
        eww open power-menu
        ;;
    audio)
        eww open audio-controls-closer
        eww open audio-controls
        ;;
    weather)
        eww open weather-popup-closer
        eww open weather-popup
        ;;
    bluetooth)
        eww open bluetooth-popup-closer
        eww open bluetooth-popup
        ;;
esac
