#!/bin/bash
echo "  === AUDIT RESEAU SYSTEME ===  "
echo -e "\n== Interfaces réseau :"
ip link show

echo -e "\n== Adresse IPs :"
ip a

echo -e "\n== Routes :"
ip route show

echo -e "\n== Firewall (nftable) :"
sudo nft list ruleset | grep -E 'table|chain|policy|accept|drop'
# sudo nft list ruleset (version simple)

echo -e "\n== Ports ouverts :"
ss -tulnp

echo -e "\n== Services écoutant :"
sudo lsof -i -n -P | grep LISTEN

echo -e "\n== DNS actuel :"
cat /etc/resolv.conf

echo -e "\n== WireGuard actif :"
sudo wg show

echo -e "\n== Variables proxy :"
env | grep -i proxy || echo "Aucun proxy défini."

echo -e "\n== Fuite IP (IPv6 ?) :"
curl -6 -s https://ifconfig.co || echo "Pas d'IPv6 détecté (curl -6 failed)"
# curl -s https://www.cloudflare.com/cdn-cgi/trace | grep ip (moins clair)

