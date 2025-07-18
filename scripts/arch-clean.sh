#!/bin/bash
# Nettoyage complet Arch Linux
set -e

# Mise a jour de l'index + upgrade
echo
echo "=== 🧹 Nettoyage Arch Linux"
echo
echo "=== ACTION : Mise à jour système..."
echo
sudo pacman -Syu

# Nettoyage paquets orphelins (pacman)
echo
echo "=== ACTION : Suppression des paquets orphelins (pacman)..."
echo
orphans=$(pacman -Qtdq 2>/dev/null || true)
if [[ -n "$orphans" ]]; then
  echo "$orphans" | xargs -r sudo pacman -Rns --noconfirm
else
  echo
  echo "=== RES : Aucun paquet orphelin trouvé"
  echo
fi

# Nettoyage cache pacman
echo
echo "=== ACTION : Nettoyage du cache pacman..."
echo
sudo paccache -rk2 && sudo paccache -ruk0

# Nettoyage cache yay (si installé)
if command -v yay &>/dev/null; then
  echo
  echo "=== ACTION : Nettoyage du cache yay..."
  echo
  yay -Sc --noconfirm <<<y
fi

# Vérif des .pacnew
echo
echo "=== ACTION : Vérification des fichiers .pacnew..."
echo
sudo DIFFPROG="nvim -d" pacdiff || true
if [[ -z $DISPLAY ]]; then
  sudo pacdiff --output # liste uniquement les fichiers
else
  sudo pacdiff # mode interactif si en session
fi

# Supprimer les logs de plus de 7 jours
echo
echo "=== ACTION = Suppression des logs..."
echo
sudo journalctl --vacuum-time=7d

# Nettoyage des snapshots
echo
echo "== ACTION : Suppression des snapshots en trop"
echo
sudo snapper -c root cleanup number

# Audit rapide et renvoie des erreurs critiques
echo
echo "=== ACTION : Audit rapide : services en échec..."
echo
systemctl --failed || true
echo
echo "=== RES : Erreurs critiques récentes :"
echo
journalctl -p 3 -xb -n 10

# Affichage de l’espace disque utilisé
echo
echo "=== RES : Espace disque:"
echo
df -h /

echo
echo "===== ✅ Nettoyage terminé."
echo
