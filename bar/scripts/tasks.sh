#!/bin/bash

# Tasks file location
TASKS_FILE="$HOME/.config/eww/tasks.json"

# Create tasks file if it doesn't exist
if [ ! -f "$TASKS_FILE" ]; then
    echo "[]" > "$TASKS_FILE"
fi

cat "$TASKS_FILE"
