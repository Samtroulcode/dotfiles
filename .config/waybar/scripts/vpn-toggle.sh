#!/bin/bash

WG_IF="wg1"

# Vérifie si l'interface est active via handshake
IS_UP=$(sudo -n wg show "$WG_IF" 2>/dev/null | grep -q "latest handshake" && echo "up" || echo "down")

if [[ "$IS_UP" == "up" ]]; then
  sudo systemctl stop "wg-quick@$WG_IF"
  notify-send "🔌 VPN" "WireGuard ($WG_IF) désactivé"
else
  sudo systemctl start "wg-quick@$WG_IF"
  sleep 1 # court délai pour éviter état intermédiaire
  if sudo -n wg show "$WG_IF" | grep -q "latest handshake"; then
    notify-send "🔒 VPN" "WireGuard ($WG_IF) activé"
  else
    notify-send "⚠️ VPN" "Échec de la connexion VPN ($WG_IF)"
  fi
fi
