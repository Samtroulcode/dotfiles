#!/bin/bash
WALL="$1"

# 1. Appliquer le wallpaper avec animation
swww img "$WALL" --transition-type wipe --transition-fps 60 --transition-duration 1

# 2. Générer et appliquer la palette Wallust
wallust run "$WALL"

# 3. Redémarrer Waybar (si tu veux que la palette soit appliquée)
# killall waybar && waybar & disown
