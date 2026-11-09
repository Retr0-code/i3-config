#!/usr/bin/env bash

brightnessctl=/usr/bin/brightnessctl

if [[ "$1" == "inc" ]]; then
    $brightnessctl -d smc::kbd_backlight s +10 > /dev/null
elif [[ "$1" == "dec" ]]; then
    $brightnessctl -d smc::kbd_backlight s 10- > /dev/null
fi
