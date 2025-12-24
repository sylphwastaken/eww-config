#!/bin/bash
read total used <<<$(free -m | awk '/Mem:/ {print $2, $3}')
echo "RAM ${used}/${total}MB"
