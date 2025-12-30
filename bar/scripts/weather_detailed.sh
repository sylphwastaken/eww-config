#!/bin/bash

API_KEY="090ccc1faa277451330d4138e2e50adb"
CITY="Waco"

# Get current weather
current=$(curl -sf "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=imperial" 2>/dev/null)

# Get forecast
forecast=$(curl -sf "https://api.openweathermap.org/data/2.5/forecast?q=${CITY}&appid=${API_KEY}&units=imperial&cnt=8" 2>/dev/null)

if [ -z "$current" ]; then
    echo '{"temp":"--","feels_like":"--","humidity":"--","wind":"--","condition":"Unknown","description":"--","icon":"","high":"--","low":"--","city":"Unknown","forecast":[]}'
    exit 0
fi

temp=$(echo "$current" | jq -r '.main.temp' | awk '{printf "%.0f", $1}')
feels_like=$(echo "$current" | jq -r '.main.feels_like' | awk '{printf "%.0f", $1}')
humidity=$(echo "$current" | jq -r '.main.humidity')
wind=$(echo "$current" | jq -r '.wind.speed' | awk '{printf "%.0f", $1}')
condition=$(echo "$current" | jq -r '.weather[0].main')
description=$(echo "$current" | jq -r '.weather[0].description')
high=$(echo "$current" | jq -r '.main.temp_max' | awk '{printf "%.0f", $1}')
low=$(echo "$current" | jq -r '.main.temp_min' | awk '{printf "%.0f", $1}')
city=$(echo "$current" | jq -r '.name')
sunrise=$(echo "$current" | jq -r '.sys.sunrise')
sunset=$(echo "$current" | jq -r '.sys.sunset')
sunrise_fmt=$(date -d @$sunrise '+%I:%M %p' 2>/dev/null || echo "--")
sunset_fmt=$(date -d @$sunset '+%I:%M %p' 2>/dev/null || echo "--")

# Get weather icon
case $condition in
    Clear) icon="☀️" ;;
    Clouds) icon="☁️" ;;
    Rain) icon="🌧️" ;;
    Drizzle) icon="🌦️" ;;
    Thunderstorm) icon="⛈️" ;;
    Snow) icon="❄️" ;;
    Mist|Fog|Haze) icon="🌫️" ;;
    *) icon="🌡️" ;;
esac

# Build forecast array
forecast_json=$(echo "$forecast" | jq -c '[.list[] | {
    time: (.dt | strftime("%I %p")),
    temp: (.main.temp | floor),
    condition: .weather[0].main,
    icon: (if .weather[0].main == "Clear" then "☀️"
           elif .weather[0].main == "Clouds" then "☁️"
           elif .weather[0].main == "Rain" then "🌧️"
           elif .weather[0].main == "Drizzle" then "🌦️"
           elif .weather[0].main == "Thunderstorm" then "⛈️"
           elif .weather[0].main == "Snow" then "❄️"
           else "🌡️" end)
}]' 2>/dev/null || echo "[]")

echo "{\"temp\":\"${temp}\",\"feels_like\":\"${feels_like}\",\"humidity\":\"${humidity}\",\"wind\":\"${wind}\",\"condition\":\"${condition}\",\"description\":\"${description}\",\"icon\":\"${icon}\",\"high\":\"${high}\",\"low\":\"${low}\",\"city\":\"${city}\",\"sunrise\":\"${sunrise_fmt}\",\"sunset\":\"${sunset_fmt}\",\"forecast\":${forecast_json}}"
