#!/bin/bash
# Nettoyage complet Arch Linux
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}=== $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Mise a jour de l'index + upgrade
echo
log_info "🧹 Nettoyage Arch Linux"
echo
log_info "ACTION : Mise à jour système..."
echo
if ! sudo pacman -Syu --noconfirm; then
    log_error "Échec de la mise à jour système"
    exit 1
fi

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
