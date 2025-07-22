#!/bin/bash

NS="browser-ns"

# Appliquer les règles nftables dans le namespace
ip netns exec "$NS" bash -c '
  nft add table inet filter 2>/dev/null || true
  nft add chain inet filter output { type filter hook output priority 0 \; policy accept \; } 2>/dev/null || true

  # Blocage des ports STUN utilisés par WebRTC
  nft add rule inet filter output udp dport 3478 drop
  nft add rule inet filter output udp dport 5349 drop
  nft add rule inet filter output udp dport 10000 drop

  echo "[✅] Règles STUN WebRTC appliquées dans le namespace : $NS"
'
