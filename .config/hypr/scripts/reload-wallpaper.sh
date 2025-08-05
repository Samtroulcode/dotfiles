#!/usr/bin/env bash

set -euo pipefail

# Configuration with environment variable fallbacks
WALLPAPER_DIR="${WALLPAPER_DIR:-${HOME}/wallpapers/Nebulix/}"
# Check if wallpaper directory exists
if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Error: Wallpaper directory $WALLPAPER_DIR not found"
  exit 1
fi

CURRENT_WALL=$(hyprctl hyprpaper listloaded 2>/dev/null || echo "")

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) ! -name "$(basename "$CURRENT_WALL" 2>/dev/null)" | shuf -n 1)

if [[ -z "$WALLPAPER" ]]; then
  echo "Error: No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Apply the selected wallpaper
if hyprctl hyprpaper reload "DP-1,$WALLPAPER" && hyprctl hyprpaper reload "HDMI-A-2,$WALLPAPER"; then
  notify-send "Wallpaper changé" "$(basename "$WALLPAPER")"
else
  echo "Error: Failed to apply wallpaper $WALLPAPER"
  exit 1
fi
