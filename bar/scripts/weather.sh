#!/bin/bash

API_KEY="090ccc1faa277451330d4138e2e50adb"
CITY="Waco"

weather=$(curl -sf "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=imperial" 2>/dev/null)

if [ -z "$weather" ]; then
    echo '{"temp":"--","condition":"","icon":""}'
    exit 0
fi

temp=$(echo "$weather" | jq -r '.main.temp' | awk '{printf "%.0f", $1}')
condition=$(echo "$weather" | jq -r '.weather[0].main')

case $condition in
    Clear) icon="☀️" ;;
    Clouds) icon="☁️" ;;
    Rain) icon="🌧️" ;;
    Thunderstorm) icon="⛈️" ;;
    Snow) icon="❄️" ;;
    Mist|Fog) icon="🌫️" ;;
    *) icon="🌡️" ;;
esac

echo "{\"temp\":\"${temp}°F\",\"condition\":\"$condition\",\"icon\":\"$icon\"}"
