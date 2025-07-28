#!/bin/bash
set -euo pipefail

# === Variables ===
NS="browser-ns"
WG_IFACE="wg-browser"
WG_CONF="/etc/wireguard/wg-browser.conf"
WG_HOST_IFACE="wg0"

VETH_HOST="veth-host"
VETH_NS="veth-ns"
HOST_IP="10.10.10.1"
NS_IP="10.10.10.2"
NS_SUBNET="10.10.10.0/24"
REMOTE_NETS=("172.18.0.0/16" "172.19.0.0/16")

RESOLV_DIR="/etc/netns/${NS}"
RESOLV_CONF="${RESOLV_DIR}/resolv.conf"
HOSTS_FILE="${RESOLV_DIR}/hosts"
DNS_HOST="${HOST_IP}"

echo "[+] Création du namespace ${NS}"
sudo ip netns add "$NS" 2>/dev/null || echo "Namespace déjà existant."

echo "[+] Ajout et configuration de WireGuard"
sudo ip link add "$WG_IFACE" type wireguard 2>/dev/null || echo "Interface déjà existante."
sudo ip link set "$WG_IFACE" netns "$NS"
sudo ip netns exec "$NS" wg setconf "$WG_IFACE" "$WG_CONF"
sudo ip netns exec "$NS" ip addr add 10.2.0.2/24 dev "$WG_IFACE" 2>/dev/null || true
sudo ip netns exec "$NS" ip link set lo up
sudo ip netns exec "$NS" ip link set "$WG_IFACE" up
sudo ip netns exec "$NS" ip route replace default dev "$WG_IFACE"

echo "[+] Lien veth host <-> namespace"
sudo ip link add "$VETH_HOST" type veth peer name "$VETH_NS" 2>/dev/null || echo "veth déjà créée"
sudo ip link set "$VETH_NS" netns "$NS"
sudo ip addr add "${HOST_IP}/24" dev "$VETH_HOST" 2>/dev/null || true
sudo ip link set "$VETH_HOST" up
sudo ip netns exec "$NS" ip addr add "${NS_IP}/24" dev "$VETH_NS" 2>/dev/null || true
sudo ip netns exec "$NS" ip link set "$VETH_NS" up

echo "[+] DNS du namespace -> dnscrypt-proxy sur le host (${DNS_HOST})"
sudo mkdir -p "$RESOLV_DIR"
echo "nameserver ${DNS_HOST}" | sudo tee "$RESOLV_CONF" >/dev/null

# (Optionnel) résolution d’un service local du host par nom:
# exemple: searxng exposé sur le host:8080
grep -q "^${HOST_IP} " "$HOSTS_FILE" 2>/dev/null ||
  echo "${HOST_IP} sam-searxng" | sudo tee -a "$HOSTS_FILE" >/dev/null

echo "[+] Activation du routage IPv4 (persistant)"
# Persistance via sysctl.d
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-browser-ns-forward.conf >/dev/null
sudo sysctl -p /etc/sysctl.d/99-browser-ns-forward.conf >/dev/null

echo "[+] Routes dans le namespace vers les réseaux distants via ${HOST_IP}"
for net in "${REMOTE_NETS[@]}"; do
  if ! sudo ip netns exec "${NS}" ip route show "${net}" | grep -q "via ${HOST_IP}"; then
    sudo ip netns exec "${NS}" ip route replace "${net}" via "${HOST_IP}" dev "${VETH_NS}"
  fi
done

echo "[+] Règles nftables: INPUT sur l'hôte (autoriser DNS et UI depuis ${NS_IP})"
# Ajouter les règles seulement si absentes (on matche sur le commentaire)
if ! sudo nft list chain inet filter input 2>/dev/null | grep -q 'browser-ns: allow DNS udp'; then
  sudo nft add rule inet filter input ip saddr ${NS_IP} ip daddr ${HOST_IP} udp dport 53 accept comment "browser-ns: allow DNS udp"
fi
if ! sudo nft list chain inet filter input 2>/dev/null | grep -q 'browser-ns: allow DNS tcp'; then
  sudo nft add rule inet filter input ip saddr ${NS_IP} ip daddr ${HOST_IP} tcp dport 53 accept comment "browser-ns: allow DNS tcp"
fi
if ! sudo nft list chain inet filter input 2>/dev/null | grep -q 'browser-ns: allow dnscrypt UI'; then
  sudo nft add rule inet filter input ip saddr ${NS_IP} ip daddr ${HOST_IP} tcp dport 8080 accept comment "browser-ns: allow dnscrypt UI"
fi

echo "[+] Règles nftables: FORWARD (veth-host <-> ${WG_HOST_IFACE})"
if ! sudo nft list chain inet filter forward 2>/dev/null | grep -q 'browser-ns: veth->wg0'; then
  sudo nft add rule inet filter forward iifname "${VETH_HOST}" oifname "${WG_HOST_IFACE}" ct state new,established,related accept comment "browser-ns: veth->wg0"
fi
if ! sudo nft list chain inet filter forward 2>/dev/null | grep -q 'browser-ns: wg0->veth'; then
  sudo nft add rule inet filter forward iifname "${WG_HOST_IFACE}" oifname "${VETH_HOST}" ct state established,related accept comment "browser-ns: wg0->veth"
fi

echo "[+] Règles nftables: NAT (masquerade ${NS_SUBNET} -> ${WG_HOST_IFACE})"
# Créer table/chaine NAT si nécessaire
if ! sudo nft list tables | grep -q '^table ip nat$'; then
  sudo nft add table ip nat
fi
if ! sudo nft list chain ip nat postrouting >/dev/null 2>&1; then
  sudo nft add chain ip nat postrouting '{ type nat hook postrouting priority 100 ; }'
fi
# Règle de masquerade (idempotente via commentaire)
if ! sudo nft list chain ip nat postrouting 2>/dev/null | grep -q 'browser-ns: nat veth->wg0'; then
  sudo nft add rule ip nat postrouting oifname "${WG_HOST_IFACE}" ip saddr ${NS_SUBNET} masquerade comment "browser-ns: nat veth->wg0"
fi

echo "[+] Vérifications rapides"
echo "  - Routes dans ${NS}:"
sudo ip netns exec "${NS}" ip r | sed 's/^/    /'
echo "  - nft INPUT (host): règles browser-ns"
sudo nft -a list chain inet filter input 2>/dev/null | grep -n 'browser-ns:' || true
echo "  - nft FORWARD (host): règles browser-ns"
sudo nft -a list chain inet filter forward 2>/dev/null | grep -n 'browser-ns:' || true
echo "  - nft NAT postrouting (host): règles browser-ns"
sudo nft -a list chain ip nat postrouting 2>/dev/null | grep -n 'browser-ns:' || true

echo "[+] Rappel: dnscrypt-proxy doit écouter sur ${HOST_IP}:53 (et l'UI sur :8080 si utilisée)."
sudo ss -ulpn | awk '/:53|:8080/ {print "    " $0}'
echo "✅ Section routage/pare-feu terminée."

echo -e "\n✅ Namespace prêt."
echo "➡ Lance qutebrowser avec : sudo -E ip netns exec ${NS} sudo -E -u \"$USER\" qutebrowser"
echo "   (ou via le wrapper 'in-ns' ci-dessous)."
