#!/bin/bash
kill -9 $1
notify-send "Process Killed" "PID: $1"
