#!/usr/bin/env bash

# === CONFIG ===
SRC="/home/sam/"
DEST="/mnt/external_backup/home_backup/"
EXCLUDES=(
  --exclude ".cache/"
  --exclude ".npm/"
  --exclude ".cargo/registry/"
  --exclude "Downloads/"
  --exclude "*/Cache/"
  --exclude "*/cache/"
  --exclude "*/tmp/"
  --exclude "*/Temp/"
  --exclude "*.lock"
  --exclude "*.tmp"
  --exclude ".Trash-*/"
  --exclude ".npm/_cacache/"
  --exclude ".local/share/Trash/"
  --exclude ".local/share/Steam/compatibilitytools.d/"
  --exclude ".steam/steam/steamapps/shadercache/"
)

# === MOUNT CHECK ===
if ! mountpoint -q /mnt/external_backup; then
  echo "❌ Disque externe non monté"
  exit 1
fi

# === BACKUP ===
echo "⏳ Sauvegarde de $SRC vers $DEST..."
rsync -avh --no-owner --no-group --delete "${EXCLUDES[@]}" "$SRC" "$DEST"

echo "✅ Sauvegarde terminée à $(date)"
