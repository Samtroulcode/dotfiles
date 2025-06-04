#!/bin/bash
# Audit système Arch Linux - Version sobre et KISS
# Ce script vérifie l'état de santé global du système Arch

set -euo pipefail

echo "=== Audit système Arch Linux ==="
echo

# Vérifier le noyau et le système
echo "[*] Version du noyau et système :"
uname -a
echo

# Vérifier uptime, RAM, disques
echo "[*] Uptime et ressources actuelles :"
uptime
free -h
df -h /
df -h /home
echo

# Vérifier les mises à jour disponibles
echo "[*] Mises à jour disponibles :"
checkupdates || echo "Pacman est à jour"
echo

# Paquets orphelins
echo "[*] Paquets orphelins (pacman) :"
orphans=$(pacman -Qdtq 2>/dev/null || true)
if [[ -n "$orphans" ]]; then
    echo "$orphans"
else
    echo "Aucun paquet orphelin"
fi
echo

# Cache pacman
echo "[*] Taille du cache pacman conservé (2 versions) :"
paccache -d -k2
echo

# Paquets AUR installés manuellement
echo "[*] Paquets installés depuis AUR :"
pacman -Qm
echo

# Dépendances AUR orphelines (yay)
echo "[*] Dépendances AUR orphelines :"
yay -Qtdq || echo "Aucune dépendance orpheline AUR"
echo

# Vérifier les services systemd activés
echo "[*] Services activés :"
systemctl list-unit-files --state=enabled
echo

# Services échoués
echo "[*] Services échoués (systemd) :"
systemctl --failed || echo "Aucun service échoué"
echo

# Logs critiques (niveau 3)
echo "[*] Derniers messages critiques (journalctl -p 3) :"
journalctl -p 3 -xb -n 15
echo

# Montages principaux
echo "[*] Montages principaux (/ et /home) :"
mount | grep -E ' / |/home'
echo

# Etat du swap
if [[ -z $(swapon --show | grep -v '^NAME') ]]; then
  echo "❌ Swap inactif !"
else
  echo "✅ Swap actif :"
  swapon --show
fi

# Fichiers pacnew en attente
echo "[*] Fichiers .pacnew détectés :"
sudo pacdiff --output || echo "Aucun fichier .pacnew"
echo

# Statut du pare-feu (ufw)
if command -v ufw &>/dev/null; then
    echo "[*] Statut UFW :"
    sudo ufw status
    echo
fi

# Locales activées
echo "[*] Locales activées :"
grep -v '^#' /etc/locale.gen
echo

# Hostname et date
echo "[*] Hostname et fuseau horaire :"
hostnamectl
timedatectl status
echo

# Hooks initramfs
echo "[*] Hooks initramfs (/etc/mkinitcpio.conf) :"
grep '^HOOKS=' /etc/mkinitcpio.conf
echo

echo "=== Fin de l'audit ==="

