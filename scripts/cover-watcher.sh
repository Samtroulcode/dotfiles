#!/bin/bash

# Dernier fichier lu (pour éviter les doublons)
last_file=""
cover=""
mp3=""

# Cacher le curseur au démarrage
tput civis

# Réafficher le curseur et nettoyer à la sortie
cleanup() {
  tput cnorm
  clear
  exit
}
trap cleanup EXIT

# Récupérer la taille du terminal (cellules et pixels)
get_terminal_size() {
  # Taille en cellules (colonnes x lignes)
  cw=$(tput cols)
  ch=$(tput lines)

  # Taille en pixels via kitty
  size=$(kitty +kitten icat --print-window-size 2>/dev/null)
  if [[ "$size" =~ ^([0-9]+)x([0-9]+) ]]; then
    pw=${BASH_REMATCH[1]}
    ph=${BASH_REMATCH[2]}
    return 0
  else
    return 1
  fi
}

# Affiche la pochette de l'album avec redimensionnement dynamique
render_cover() {
  [[ ! -f "$cover" ]] && return

  if get_terminal_size; then
    kitty +kitten icat \
      --stdin=no \
      --transfer-mode file \
      --use-window-size "${cw},${ch},${pw},${ph}" \
      --align center \
      --scale-up \
      --clear \
      "$cover"
  fi
}

# Extrait la jaquette d’un fichier MP3 (s’il y en a une)
extract_cover() {
  cover_dir="$(dirname "$mp3")"
  base="$(basename "$mp3" .mp3)"
  cover="$cover_dir/${base}.jpg"

  # Si pas de cover existante, tenter extraction
  if [[ ! -f "$cover" ]]; then
    ffmpeg -loglevel quiet -y -i "$mp3" -an -vcodec copy "$cover"
  fi
}

# Re-affiche l’image en cas de redimensionnement du terminal
on_resize() {
  clear
  render_cover
}
trap on_resize SIGWINCH

# Boucle de surveillance de lecture
while true; do
  current=$(mpc --format "%file%" current)

  # Si nouveau fichier détecté
  if [[ -n "$current" && "$current" != "$last_file" ]]; then
    mp3="$HOME/Storage/Music/$current"
    last_file="$current"
    clear
    extract_cover
    render_cover
  fi

  sleep 1
done
