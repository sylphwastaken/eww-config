
#!/bin/bash

# Configuration

API_KEY="090ccc1faa277451330d4138e2e50adb"

CITY="Waco,US"  # City,CountryCode format

UNITS="imperial"  # imperial for Fahrenheit, metric for Celsius

# Fetch weather data

response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=${UNITS}")

# Check if request was successful

if [ -z "$response" ] || echo "$response" | grep -q "error"; then

    echo "{\"icon\":\"❓\",\"temp\":\"N/A\",\"condition\":\"Error\"}"

    exit 0

fi

# Parse JSON response

temp=$(echo "$response" | jq -r '.main.temp // "N/A"' | cut -d. -f1)

condition=$(echo "$response" | jq -r '.weather[0].main // "Unknown"')

weather_id=$(echo "$response" | jq -r '.weather[0].id // "0"')

# Determine emoji based on weather condition ID

# OpenWeatherMap condition codes: https://openweathermap.org/weather-conditions

if [ "$weather_id" -ge 200 ] && [ "$weather_id" -lt 300 ]; then

    icon="⛈️"  # Thunderstorm

elif [ "$weather_id" -ge 300 ] && [ "$weather_id" -lt 400 ]; then

    icon="🌦️"  # Drizzle

elif [ "$weather_id" -ge 500 ] && [ "$weather_id" -lt 600 ]; then

    icon="🌧️"  # Rain

elif [ "$weather_id" -ge 600 ] && [ "$weather_id" -lt 700 ]; then

    icon="❄️"  # Snow

elif [ "$weather_id" -ge 700 ] && [ "$weather_id" -lt 800 ]; then

    icon="🌫️"  # Atmosphere (fog, mist, etc)

elif [ "$weather_id" -eq 800 ]; then

    icon="☀️"  # Clear

elif [ "$weather_id" -eq 801 ]; then

    icon="🌤️"  # Few clouds

elif [ "$weather_id" -eq 802 ]; then

    icon="⛅"  # Scattered clouds

elif [ "$weather_id" -ge 803 ]; then

    icon="☁️"  # Overcast

else

    icon="🌡️"  # Default

fi

echo "{\"icon\":\"$icon\",\"temp\":\"${temp}°F\",\"condition\":\"$condition\"}"

