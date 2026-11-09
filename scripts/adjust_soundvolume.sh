#!/usr/bin/env bash

pactl=/usr/bin/pactl
notify_send=/usr/bin/notify-send

MAX_VOLUME=100

# Function to get the current volume
get_current_volume() {
    $pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//'
}

function notify() {
    local VOLUME_PERCENT=$(get_current_volume)
    $notify_send -t 1500 -a "Volume" -u normal -h int:value:${VOLUME_PERCENT} "Volume ${VOLUME_PERCENT}%"
}

function notify_mute() {
    local MUTED_STATUS=$($pactl get-sink-mute @DEFAULT_SINK@)
    $notify_send -t 1500 -a "Volume" -u normal "Volume ${MUTED_STATUS}"
}

# Perform volume adjustment
if [[ "$1" == "inc" ]]; then
    [ "$(get_current_volume)" -lt $MAX_VOLUME ] && $pactl set-sink-volume @DEFAULT_SINK@ +10%
    notify
elif [[ "$1" == "dec" ]]; then
    $pactl set-sink-volume @DEFAULT_SINK@ -10%
    notify
elif [[ "$1" == "mute" ]]; then
    $pactl set-sink-mute @DEFAULT_SINK@ toggle
    notify_mute
fi
