#!/bin/bash
set -e

# === Variables ===
NS="browser-ns"
WG_IFACE="wg-browser"
WG_CONF="/etc/wireguard/wg-browser.conf"

VETH_HOST="veth-host"
VETH_NS="veth-ns"
HOST_IP="10.10.10.1"
NS_IP="10.10.10.2"
PROXY_PORT=1080
RESOLV_CONF="/etc/netns/${NS}/resolv.conf"

# === 1. Créer le namespace ===
echo "[+] Création du namespace $NS"
sudo ip netns add "$NS" 2>/dev/null || echo "Namespace $NS déjà existant."

# === 2. WireGuard ===
echo "[+] Ajout de l'interface WireGuard"
sudo ip link add "$WG_IFACE" type wireguard 2>/dev/null || echo "Interface déjà existante."
sudo ip link set "$WG_IFACE" netns "$NS"

echo "[+] Configuration WireGuard"
sudo ip netns exec "$NS" wg setconf "$WG_IFACE" "$WG_CONF"
sudo ip netns exec "$NS" ip addr add 10.2.0.2/24 dev "$WG_IFACE"
sudo ip netns exec "$NS" ip link set "$WG_IFACE" up

# === 3. Config réseau du namespace ===
echo "[+] Réseaux internes dans le namespace"
sudo ip netns exec "$NS" ip link set lo up
sudo ip netns exec "$NS" ip route add default dev "$WG_IFACE"

# === 4. Interface veth pour communication host <-> namespace ===
echo "[+] Création du lien veth"
sudo ip link add "$VETH_HOST" type veth peer name "$VETH_NS" 2>/dev/null || echo "veth déjà créée"
sudo ip link set "$VETH_NS" netns "$NS"

sudo ip addr add "$HOST_IP/24" dev "$VETH_HOST" 2>/dev/null || true
sudo ip link set "$VETH_HOST" up

sudo ip netns exec "$NS" ip addr add "$NS_IP/24" dev "$VETH_NS" 2>/dev/null || true
sudo ip netns exec "$NS" ip link set "$VETH_NS" up

# === 5. Config DNS (vers dnscrypt-proxy local) ===
echo "[+] Configuration DNS vers dnscrypt-proxy ($HOST_IP)"
sudo mkdir -p "$(dirname "$RESOLV_CONF")"
echo "nameserver $HOST_IP" | sudo tee "$RESOLV_CONF" >/dev/null

# === 6. Lancer microsocks ===
echo "[+] Lancement de microsocks dans $NS sur $NS_IP:$PROXY_PORT"
sudo pkill -f "microsocks.*-i $NS_IP" 2>/dev/null || true
sudo nohup ip netns exec "$NS" microsocks -i "$NS_IP" -p "$PROXY_PORT" >/dev/null 2>&1 &

# === 7. Ajouter règles nftables temporaires ===
echo "[+] Ajout des règles nftables (DNS)"
sudo nft add rule inet filter input ip saddr "$NS_IP" ip daddr "$HOST_IP" udp dport 53 accept 2>/dev/null || true
sudo nft add rule inet filter input ip saddr "$NS_IP" ip daddr "$HOST_IP" tcp dport 53 accept 2>/dev/null || true

# === 8. Affichage final ===
echo -e "\n✅ Configuration terminée !"
echo "➡ Qutebrowser doit utiliser le proxy SOCKS : socks://${NS_IP}:${PROXY_PORT}"
echo "➡ Le namespace utilise WireGuard et DNS sécurisé (dnscrypt-proxy sur le host)"
