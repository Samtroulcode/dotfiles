#!/bin/bash
set -euo pipefail

WALL="$1"

TEMPLATE="$HOME/.config/neofetch/png/logo-template.svg"
OUTPUT_DIR="$HOME/.cache/neofetch/png"

mkdir -p "$OUTPUT_DIR"

# ----------------------------
# Utils
# ----------------------------

require() {
  command -v "$1" >/dev/null 2>&1 || {
    notify-send "Wallpaper Error" "Dépendance manquante: $1"
    exit 1
  }
}

ensure_poster() {
  local video="$1"
  local poster="${video%.*}.poster.webp"

  [[ -f "$poster" ]] && { echo "$poster"; return 0; }

  notify-send "Wallpaper (animated)" \
    "Poster absent, génération en cours…\n$(basename "$poster")"

  ffmpeg -loglevel error \
    -ss 00:00:01 \
    -i "$video" \
    -vframes 1 \
    -vf "scale=1280:-2" \
    "$poster"

  [[ -f "$poster" ]] && echo "$poster" && return 0

  notify-send "Wallpaper Error" \
    "Impossible de générer le poster:\n$(basename "$video")"
  return 1
}

# ----------------------------
# Checks
# ----------------------------

require wallust
require jq
require rsvg-convert

case "$WALL" in
  *.mp4|*.webm|*.mkv|*.gif|*.apng)
    require mpvpaper
    require ffmpeg
    IS_ANIMATED=true
    ;;
  *)
    require swww
    IS_ANIMATED=false
    ;;
esac

# ----------------------------
# Apply wallpaper
# ----------------------------

pkill mpvpaper 2>/dev/null || true

if $IS_ANIMATED; then
  mpvpaper -o "--no-config --loop --no-audio --hwdec=auto-safe --really-quiet" '*' "$WALL" &
  POSTER="$(ensure_poster "$WALL")"
  wallust run -s "$POSTER"
else
  swww img "$WALL" \
    --transition-type wipe \
    --transition-fps 60 \
    --transition-duration 1
  wallust run -s "$WALL"
fi

# ----------------------------
# Neofetch recolor
# ----------------------------

COLOR=$(jq -r '.accent' ~/.cache/wal/colors.json)

OUTPUT_SVG="$OUTPUT_DIR/logo-$(date +%s).svg"
OUTPUT_PNG="$OUTPUT_DIR/logo-colored-$(date +%s).png"

sed "s/fill=\"#000000\"/fill=\"$COLOR\"/" "$TEMPLATE" >"$OUTPUT_SVG"
rsvg-convert -w 350 -h 350 "$OUTPUT_SVG" >"$OUTPUT_PNG"

