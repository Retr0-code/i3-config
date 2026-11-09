#!/usr/bin/env bash

bc=/usr/bin/bc
notify_send=/usr/bin/notify-send
brightnessctl=/usr/bin/brightnessctl

MIN_BRIGHTNESS=10

function get_brightness() {
    local MAX_BRIGHTNESS=$($brightnessctl max)
    local CURRENT_BRIGHTNESS=$($brightnessctl get)
    # $bc <<< "scale=1; $CURRENT_BRIGHTNESS / $MAX_BRIGHTNESS * 100"
    echo $(($CURRENT_BRIGHTNESS * 100 / $MAX_BRIGHTNESS))
}

function notify_brightness() {
    BRIGHTNESS_PERCENT=$(get_brightness)
    $notify_send -t 1500 -a "Brightness" -u normal -h int:value:${BRIGHTNESS_PERCENT} "Brightness ${BRIGHTNESS_PERCENT}%"
}

if [[ "$1" == "inc" ]]; then
    $brightnessctl set +5% > /dev/null
    notify_brightness
elif [[ "$1" == "dec" ]]; then
    echo "$(get_brightness)" 
    [ "$(get_brightness)" -gt $MIN_BRIGHTNESS ] && $brightnessctl set 5%- > /dev/null
    notify_brightness
fi
