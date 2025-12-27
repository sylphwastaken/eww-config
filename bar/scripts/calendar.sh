#!/bin/bash

# Get current date info
current_month=$(date +%m)
current_year=$(date +%Y)
current_day=$(date +%d)

# Get first day of month (0=Sunday, 1=Monday, etc)
first_day=$(date -d "$current_year-$current_month-01" +%u)
# Adjust so Monday = 0
first_day=$((first_day % 7))

# Get days in current month
days_in_month=$(date -d "$current_year-$current_month-01 +1 month -1 day" +%d)

# Get month name
month_name=$(date +%B)

# Build days array
days="["
for ((i=1; i<=days_in_month; i++)); do
    is_today="false"
    if [ $i -eq $((10#$current_day)) ]; then
        is_today="true"
    fi
    
    # Check if day has tasks (we'll implement this later)
    has_tasks="false"
    
    if [ $i -gt 1 ]; then
        days+=","
    fi
    days+="{\"day\":$i,\"today\":$is_today,\"tasks\":$has_tasks}"
done
days+="]"

echo "{\"month\":\"$month_name\",\"year\":$current_year,\"first_day\":$first_day,\"days\":$days,\"current_day\":$current_day}"
