#!/usr/bin/env bash
set -euo pipefail

STATIC_DIR="$HOME/wallpapers/static"
ANIMATED_DIR="$HOME/wallpapers/animated"
CACHE_DIR="$HOME/.cache/wallpaper-selector"

THUMB_W=250
THUMB_H=141

mkdir -p "$CACHE_DIR"

echo "[cache] static wallpapers"
find "$STATIC_DIR" -maxdepth 1 -type f -print0 |
while IFS= read -r -d '' img; do
  thumb="$CACHE_DIR/$(basename "$img").png"
  [[ -f "$thumb" && "$thumb" -nt "$img" ]] && continue

  magick "$img" \
    -thumbnail "${THUMB_W}x${THUMB_H}^" \
    -gravity center \
    -extent "${THUMB_W}x${THUMB_H}" \
    "$thumb"
done

echo "[cache] animated wallpapers"
find "$ANIMATED_DIR" -maxdepth 1 -type f \( \
    -iname '*.mp4' -o -iname '*.webm' -o -iname '*.mkv' \
  \) -print0 |
while IFS= read -r -d '' vid; do
  poster="${vid%.*}.poster.webp"
  thumb="$CACHE_DIR/$(basename "$poster").png"

  if [[ ! -f "$poster" ]]; then
    ffmpeg -loglevel error \
      -ss 00:00:01 -i "$vid" \
      -vframes 1 -vf "scale=1280:-2" \
      "$poster"
  fi

  [[ -f "$thumb" && "$thumb" -nt "$poster" ]] && continue

  magick "$poster" \
    -thumbnail "${THUMB_W}x${THUMB_H}^" \
    -gravity center \
    -extent "${THUMB_W}x${THUMB_H}" \
    "$thumb"
done

echo "[cache] done"

