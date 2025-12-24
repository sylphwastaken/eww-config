#!/bin/bash
ps aux --sort=-%cpu | awk 'NR>1 && NR<=51 {
    cmd = $11
    gsub(/^.*\//, "", cmd)
    gsub(/\s.*$/, "", cmd)
    
    if (cmd in processes) {
        processes[cmd]["pids"] = processes[cmd]["pids"] "," $2
        processes[cmd]["cpu"] += $3
        processes[cmd]["count"]++
        
        idx = processes[cmd]["count"]
        children[cmd][idx]["pid"] = $2
        children[cmd][idx]["cpu"] = $3
    } else {
        processes[cmd]["pids"] = $2
        processes[cmd]["cpu"] = $3
        processes[cmd]["count"] = 1
        process_list[++proc_count] = cmd
        
        children[cmd][1]["pid"] = $2
        children[cmd][1]["cpu"] = $3
    }
}
END {
    # Sort processes by CPU usage
    for (i = 1; i <= proc_count; i++) {
        for (j = i + 1; j <= proc_count; j++) {
            if (processes[process_list[i]]["cpu"] < processes[process_list[j]]["cpu"]) {
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
        total_cpu = processes[cmd]["cpu"]
        
        printf "{\"name\":\"%s\",\"count\":%d,\"total_percent\":\"%.1f\",\"total_value\":\"%.1f%%\",\"pids\":\"%s\",\"children\":[", 
            cmd, processes[cmd]["count"], total_cpu, total_cpu, pids
        
        first_child = 1
        for (i = 1; i <= processes[cmd]["count"]; i++) {
            if (children[cmd][i]["pid"] != "") {
                if (!first_child) printf ","
                first_child = 0
                printf "{\"pid\":\"%s\",\"percent\":\"%.1f\",\"value\":\"%.1f%%\"}", 
                    children[cmd][i]["pid"], children[cmd][i]["cpu"], children[cmd][i]["cpu"]
            }
        }
        printf "]}"
    }
    printf "]"
}'
