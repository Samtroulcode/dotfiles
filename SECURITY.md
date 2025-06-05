# 🔐 SECURITY.md – Sécurité réseau système (Arch Linux + Hyprland)

## ✅ Objectif
Ce fichier documente la configuration de sécurité réseau en place. Il est destiné à :
- Faciliter les vérifications
- Garder un historique de durcissement
- Être lisible dans xplr, Homarr, ou en ligne de commande

---

## 🌍 Réseau

### Interfaces actives :
- `enp3s0` : Interface Ethernet principale (IPv4 only)
- `wg0` : Tunnel WireGuard vers le serveur
- `lo` : Interface loopback

### Routage :
- Par défaut via `enp3s0`
- `wg0` utilisé uniquement pour le sous-réseau `10.100.0.0/24`

---

## 🔐 WireGuard

- Interface active : `wg0`
- But : tunnel vers serveur, **pas de redirection de tout le trafic**
- Tunnel **split**, avec :
  ```
  AllowedIPs = 10.100.0.0/24
  ```

---

## 🌐 DNS

### DNS système :
- Géré manuellement via `/etc/resolv.conf`
- Serveur : `116.202.176.26` (LibreDNS – respectueux, libre, sans logs)
- Fichier protégé en écriture :
  ```bash
  sudo chattr +i /etc/resolv.conf
  ```

### DNS navigateur (LibreWolf) :
- DNS-over-HTTPS strict (`network.trr.mode = 3`)
- Serveur DoH : `https://libredns.gr/dns-query`
- Bootstrap DNS : `116.202.176.26`

---

## 🚫 IPv6

- Totalement désactivé via :
  ```
  net.ipv6.conf.all.disable_ipv6 = 1
  net.ipv6.conf.default.disable_ipv6 = 1
  net.ipv6.conf.lo.disable_ipv6 = 1
  ```
- Script toggle rapide :
  ```
  ipv6-off  # désactive
  ipv6-on   # réactive
  ```

---

## 🔥 Pare-feu (UFW)

- Statut : `actif`
- Règle par défaut : 
  - `deny incoming`
  - `allow outgoing`
- Ports autorisés :
  - `22/tcp` (SSH, local ou vers le serveur)
- IPv6 : règles également présentes mais IPv6 désactivé

---

## 🔎 Audit & Vérification

Alias utiles dans `.zshrc` :
```bash
alias ipv6-off='~/scripts/toggle_ipv6.sh off'
alias ipv6-on='~/scripts/toggle_ipv6.sh on'
alias audit-net='~/scripts/audit_network.sh'
alias dnscheck='resolvectl status | grep Current'
alias myip='curl ifconfig.me'
alias wgstatus='sudo wg show'
```

Script d’audit réseau :
```
~/scripts/audit_network.sh
```

---

## 🎮 Jeux et multimédia

- Jeux Steam, Epic, Discord : ✅ IPv4 fallback OK
- Pas d’impact du blocage IPv6
- Discord partage d’écran via Chromium : ✅
- VPN WireGuard : ne redirige pas tout le trafic (split OK)

---

## 📦 Résumé technique

| Élément          | État              |
|------------------|-------------------|
| IPv6             | ❌ Désactivé      |
| Firewall         | ✅ Actif (UFW)    |
| DNS              | ✅ LibreDNS (DoH) |
| VPN              | ✅ WireGuard split |
| IP publique      | ✅ IPv4 only      |
| Fuites détectées | ❌ Aucune         |
| Jeux / Discord   | ✅ Fonctionnels   |

---
