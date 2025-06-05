#!/bin/bash
echo "  === AUDIT RESEAU SYSTEME ===  "
echo -e "\n== Interfaces réseau :"
ip link show

echo -e "\n== Adresse IPs :"
ip a

echo -e "\n== Routes :"
ip route show

echo -e "\n== Firewall (ufw) :"
sudo ufw status verbose

echo -e "\n== Ports ouverts :"
ss -tulnp

echo -e "\n== Services écoutant :"
sudo lsof -i -n -P | grep LISTEN

echo -e "\n== DNS actuel :"
cat /etc/resolv.conf
resolvectl status | grep -E 'DNS|Server|Fallback'

echo -e "\n== WireGuard actif :"
sudo wg show

echo -e "\n== Variables proxy :"
env | grep -i proxy || echo "Aucun proxy défini."

echo -e "\n== Fuite IP (IPv6 ?) :"
curl -s https://www.cloudflare.com/cdn-cgi/trace | grep ip

