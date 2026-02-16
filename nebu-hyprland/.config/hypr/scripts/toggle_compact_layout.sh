#!/usr/bin/env bash

STATE_FILE="$HOME/.cache/hypr_compact_layout"

if [[ -f "$STATE_FILE" ]]; then
    # Retour mode normal
    hyprctl keyword general:gaps_in 10
    hyprctl keyword general:gaps_out 20
    hyprctl keyword general:border_size 4
    hyprctl keyword decoration:rounding 0

    rm "$STATE_FILE"
else
    # Mode compact
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:border_size 2
    hyprctl keyword decoration:rounding 0

    touch "$STATE_FILE"
fi

