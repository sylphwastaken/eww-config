#!/bin/bash
speed=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits 2>/dev/null)
if [ -n "$speed" ]; then
    echo "${speed}MHz"
else
    echo "N/A"
fi
