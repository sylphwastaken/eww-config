#!/bin/bash
# For NVIDIA
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-compute-apps=pid,name,used_memory --format=csv,noheader,nounits 2>/dev/null | head -10 | awk -F', ' '{printf "{\"pid\":\"%s\",\"name\":\"%s\",\"percent\":\"N/A\",\"value\":\"%sMB\"},", $1, $2, $3}' | sed 's/,$//' | awk '{print "["$0"]"}'
else
    echo '[]'
fi
