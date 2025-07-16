#!/bin/bash

WALLDIR="$HOME/wallpapers"

nsxiv -t "$WALLDIR" | while read -r selected; do
  [[ -f "$selected" ]] || exit 1
  $HOME/.config/wallust/set_wall.sh "$selected"
done
