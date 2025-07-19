#!/usr/bin/env bash
# Configuration
WALLPAPER_DIR="$HOME/wallpapers/Wallust-certified" # wallpaper directory
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250" # Size of thumbnails in pixels (16:9)
THUMBNAIL_HEIGHT="141"
# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to generate thumbnail
generate_thumbnail() {
  local input="$1"
  local output="$2"
  magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
}

# Créer l'icone random au vol
SHUFFLE_ICON="$CACHE_DIR/shuffle.png"
magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:#1e1e2e \
  \( "$HOME/wallpapers/shuffle.png" -resize "80x80" \) \
  -gravity center -composite "$SHUFFLE_ICON"

# Generate thumbnails and create menu items
generate_menu() {
  # Add random/shuffle option with a name that sorts first (using ! prefix)
  echo -en "img:$SHUFFLE_ICON\x00info:!Random Wallpaper\x1fRANDOM\n"

  # Then add all wallpapers
  for img in "$WALLPAPER_DIR"/*; do
    # Skip if no matches found
    [[ -f "$img" ]] || continue

    # Generate thumbnail filename
    thumbnail="$CACHE_DIR/$(basename "${img%.*}").png"

    # Generate thumbnail if it doesn't exist or is older than source
    if [[ ! -f "$thumbnail" ]] || [[ "$img" -nt "$thumbnail" ]]; then
      generate_thumbnail "$img" "$thumbnail"
    fi

    # Output menu item (filename and path)
    echo -en "img:$thumbnail\x00info:$(basename "$img")\x1f$img\n"
  done
}

# Use wofi to display grid of wallpapers
selected=$(
  generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
    --columns 3 \
    --allow-images \
    --insensitive \
    --sort-order=default \
    --prompt "Select Wallpaper" \
    --location "top" \
    --style ~/.config/wofi/wallust-style.css \
    --conf ~/.config/wofi/wallpaper.conf
)

# Set un wallpaper si un est séléctionné
if [ -n "$selected" ]; then
  # Remove the img: prefix
  thumbnail_path="${selected#img:}"

  if [[ "$thumbnail_path" == "$SHUFFLE_ICON" ]]; then
    # Shuffle parmi tous les fichiers images (détectés sans se baser sur les extensions)
    original_path=$(find "$WALLPAPER_DIR" -type f -exec file --mime-type {} \; | grep -E 'image/' | cut -d: -f1 | shuf -n 1)
  else
    # Retrouve le fichier original correspondant au thumbnail
    original_basename="$(basename "${thumbnail_path%.*}")"

    # Recherche un fichier dans le dossier des wallpapers qui porte ce nom exact (sans extension)
    original_path=$(find "$WALLPAPER_DIR" -type f -exec bash -c '
      for f; do
        [[ "$(basename "${f%.*}")" == "'"$original_basename"'" ]] && echo "$f" && break
      done
    ' _ {} +)
  fi

  if [ -n "$original_path" ]; then
    /home/sam/.config/wallust/set_wall.sh "$original_path"
    echo "$original_path" >"$HOME/.cache/current_wallpaper"
    notify-send "Wallpaper" "Wallpaper has been updated" -i "$original_path"
  else
    notify-send "Wallpaper Error" "Could not find the original wallpaper file."
  fi
fi
