#!/usr/bin/env bash

WALLPAPER_DIR="/home/sam/wallpapers/Nebulix/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
hyprctl hyprpaper reload DP-1, $WALLPAPER
hyprctl hyprpaper reload HDMI-A-2, $WALLPAPER

notify-send "Wallpaper changé" "$WALLPAPER"
