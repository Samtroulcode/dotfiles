#!/bin/bash
set -e

echo "🗂️  Sauvegarde de /home/sam vers /backup/home-sam"
rsync -avh --delete /home/sam/ /backup/home-sam/

echo
echo "✅ Sauvegarde terminée le $(date)"
echo
