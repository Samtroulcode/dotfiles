#!/bin/bash

WG_INTERFACE="wg1"
HANDSHAKE=$(sudo -n wg show "$WG_INTERFACE" | awk '/latest handshake:/ {print $3}')

if [[ "$HANDSHAKE" == "Never" || -z "$HANDSHAKE" ]]; then
  # Pas de handshake = VPN inactif
  echo '{"text": "", "class": "vpn-off", "tooltip": "VPN déconnecté"}'
else
  # Handshake présent = VPN actif
  echo '{"text": "", "class": "vpn-on", "tooltip": "VPN connecté"}'
fi
