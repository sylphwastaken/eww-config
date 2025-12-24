#!/bin/bash
read cpu user nice system idle iowait irq softirq steal < /proc/stat
total=$((user+nice+system+idle+iowait+irq+softirq+steal))
idle_total=$((idle+iowait))
sleep 0.2
read cpu user nice system idle iowait irq softirq steal < /proc/stat
total2=$((user+nice+system+idle+iowait+irq+softirq+steal))
idle_total2=$((idle+iowait))
usage=$((100*( (total2-total)-(idle_total2-idle_total) )/(total2-total)))
freq=$(awk '{print int($1/1000)}' /proc/cpuinfo | head -1)
echo "CPU ${usage}% @ ${freq}MHz"
