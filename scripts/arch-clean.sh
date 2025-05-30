#!/bin/bash
# Nettoyage complet Arch Linux
set -e

# Mise a jour de l'index + upgrade
echo "🧹 Nettoyage Arch Linux"
echo "🔄 Mise à jour système..."
sudo pacman -Syu

# Nettoyage paquets orphelins (pacman)
echo "🧼 Suppression des paquets orphelins (pacman)..."
orphans=$(pacman -Qtdq 2>/dev/null || true)
if [[ -n "$orphans" ]]; then
  echo "$orphans" | xargs -r sudo pacman -Rns
else
  echo "✅ Aucun paquet orphelin trouvé."
fi

# Nettoyage cache pacman
echo "🧽 Nettoyage du cache pacman..."
sudo paccache -r

# Nettoyage cache yay (si installé)
if command -v yay &>/dev/null; then
  echo "🧽 Nettoyage du cache yay..."
  yay -Sc --noconfirm
fi

# Vérif des .pacnew
echo "🔍 Vérification des fichiers .pacnew..."
sudo pacdiff

# Audit rapide et renvoie des erreurs critiques
echo "🩺 Audit rapide : services en échec"
systemctl --failed || true
echo "🧾 Erreurs critiques récentes :"
journalctl -p 3 -xb -n 10

echo "✅ Nettoyage terminé."
