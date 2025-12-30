#!/bin/bash
get_pairs() {
    max_pair=$(cat /tmp/eww_max_ws_pair 2>/dev/null || echo "3")
    pairs="["
    for i in $(seq 1 $max_pair); do
        ws1=$(( (i - 1) * 2 + 1 ))
        ws2=$(( ws1 + 1 ))
        [ $i -gt 1 ] && pairs+=","
        pairs+="{\"pair\":$i,\"ws1\":$ws1,\"ws2\":$ws2}"
    done
    pairs+="]"
    echo "$pairs"
}

get_pairs

# Watch for changes
while inotifywait -q -e modify /tmp/eww_max_ws_pair 2>/dev/null; do
    get_pairs
done
