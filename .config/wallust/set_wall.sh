#!/bin/bash
WALL="$1"
TEMPLATE="$HOME/.config/neofetch/png/logo-template.svg"
OUTPUT_DIR="$HOME/.cache/neofetch/png"
TIMESTAMP=$(date +%s)
OUTPUT_SVG="$OUTPUT_DIR/logo-$TIMESTAMP.svg"
OUTPUT_PNG="$OUTPUT_DIR/logo-colored-$TIMESTAMP.png"
LINK_PNG="$OUTPUT_DIR/logo-colored.png"

rm -f "$OUTPUT_DIR"/*.png "$OUTPUT_DIR"/*.svg

# 1. Appliquer le wallpaper avec animation
swww img "$WALL" --transition-type wipe --transition-fps 60 --transition-duration 1

# 2. Générer et appliquer la palette Wallust
wallust run -s "$WALL"

# 3. Récupérer la couleur accent
COLOR=$(jq -r '.accent' ~/.cache/wal/colors.json)

# 4. Créer le dossier si absent
mkdir -p "$OUTPUT_DIR"

# 5. Nettoyer les anciens fichiers (sauf le lien stable)
find "$OUTPUT_DIR" -type f -name 'logo-colored-*.png' -mmin +1 -delete
find "$OUTPUT_DIR" -type f -name 'logo-*.svg' -mmin +1 -delete

# 6. Recolorer le SVG → SVG temporaire
sed "s/fill=\"#000000\"/fill=\"$COLOR\"/" "$TEMPLATE" >"$OUTPUT_SVG"

# 7. Convertir SVG → PNG
rsvg-convert -w 350 -h 350 "$OUTPUT_SVG" >"$OUTPUT_PNG"
