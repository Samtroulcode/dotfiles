#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded | grep 'path:' | awk '{print $2}' | xargs basename)

# Choisir un wallpaper aléatoire différent
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$CURRENT_WALL" | shuf -n 1)

# Appliquer le même wallpaper à tous les moniteurs
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALLPAPER"

for MON in $(hyprctl monitors -j | jq -r '.[].name'); do
  hyprctl hyprpaper wallpaper "$MON,$WALLPAPER"
done

