#!/bin/bash

STATE="$1"

if [[ "$STATE" == "off" ]]; then
  echo "=== Désactivation d'IPv6..."
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
elif [[ "$STATE" == "on" ]]; then
  echo "=== Réactivation d'IPv6..."
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
  sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=0
else
  echo "=== Usage: $0 [on|off] ==="
  exit 1
fi

