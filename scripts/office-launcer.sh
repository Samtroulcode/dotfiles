#!/bin/bash
fichier=$(find ~/Documents ~/Downloads ~/ -type f \( -iname "*.pdf" -o -iname "*.csv" -o -iname "*.xlsx" \) | rofi -dmenu -p "Ouvrir un fichier")

case "$fichier" in
*.pdf) zathura "$fichier" & ;;
*.csv) alacritty -e sc-im "$fichier" ;;
*.xlsx)
  tmpfile="/tmp/$(basename "$fichier" .xlsx).csv"
  xlsx2csv "$fichier" "$tmpfile" && alacritty -e sc-im "$tmpfile"
  ;;
esac
