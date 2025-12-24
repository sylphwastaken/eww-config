#!/bin/bash
grep "cpu MHz" /proc/cpuinfo | head -1 | awk '{printf "%.1fGHz", $4/1000}'
