#!/bin/bash
ps aux --sort=-%mem | awk 'NR>1 && NR<=51 {
    cmd = $11
    gsub(/^.*\//, "", cmd)
    gsub(/\s.*$/, "", cmd)
    
    mem_mb = int($6/1024)
    
    if (cmd in processes) {
        processes[cmd]["pids"] = processes[cmd]["pids"] "," $2
        processes[cmd]["mem"] += $4
        processes[cmd]["mem_mb"] += mem_mb
        processes[cmd]["count"]++
        
        idx = processes[cmd]["count"]
        children[cmd][idx]["pid"] = $2
        children[cmd][idx]["mem"] = $4
        children[cmd][idx]["mem_mb"] = mem_mb
    } else {
        processes[cmd]["pids"] = $2
        processes[cmd]["mem"] = $4
        processes[cmd]["mem_mb"] = mem_mb
        processes[cmd]["count"] = 1
        process_list[++proc_count] = cmd
        
        children[cmd][1]["pid"] = $2
        children[cmd][1]["mem"] = $4
        children[cmd][1]["mem_mb"] = mem_mb
    }
}
END {
    # Sort processes by memory usage
    for (i = 1; i <= proc_count; i++) {
        for (j = i + 1; j <= proc_count; j++) {
            if (processes[process_list[i]]["mem"] < processes[process_list[j]]["mem"]) {
                temp = process_list[i]
                process_list[i] = process_list[j]
                process_list[j] = temp
            }
        }
    }
    
    printf "["
    first = 1
    limit = (proc_count < 15 ? proc_count : 15)
    for (n = 1; n <= limit; n++) {
        cmd = process_list[n]
        if (!first) printf ","
        first = 0
        
        pids = processes[cmd]["pids"]
        total_mem = processes[cmd]["mem"]
        total_mem_mb = processes[cmd]["mem_mb"]
        
        printf "{\"name\":\"%s\",\"count\":%d,\"total_percent\":\"%.1f\",\"total_value\":\"%dMB\",\"pids\":\"%s\",\"children\":[", 
            cmd, processes[cmd]["count"], total_mem, total_mem_mb, pids
        
        first_child = 1
        for (i = 1; i <= processes[cmd]["count"]; i++) {
            if (children[cmd][i]["pid"] != "") {
                if (!first_child) printf ","
                first_child = 0
                printf "{\"pid\":\"%s\",\"percent\":\"%.1f\",\"value\":\"%dMB\"}", 
                    children[cmd][i]["pid"], children[cmd][i]["mem"], children[cmd][i]["mem_mb"]
            }
        }
        printf "]}"
    }
    printf "]"
}'
