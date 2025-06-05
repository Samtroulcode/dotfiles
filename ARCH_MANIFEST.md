# 🏩 ARCH\_MANIFEST.md

![Arch](https://img.shields.io/badge/arch-linux-blue?logo=arch-linux\&logoColor=white)
![Zsh](https://img.shields.io/badge/shell-zsh-4EAA25?logo=gnu-bash\&logoColor=white)
![KISS](https://img.shields.io/badge/philosophie-KISS-9cf)
![Wayland](https://img.shields.io/badge/Wayland-enabled-success?logo=wayland)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-green?logo=windowmaker)
![LibreWolf](https://img.shields.io/badge/browser-LibreWolf-blue?logo=firefoxbrowser)
![NoFlatpak](https://img.shields.io/badge/NO-snap/flatpak-red)
![Dotfiles](https://img.shields.io/badge/dotfiles-git--bare-orange)
![ufw](https://img.shields.io/badge/firewall-ufw-critical?logo=ubuntu)
![WireGuard](https://img.shields.io/badge/VPN-WireGuard-7B7B7B?logo=wireguard)
![IPv6](https://img.shields.io/badge/IPv6-disabled-lightgrey)
![rsync](https://img.shields.io/badge/backup-rsync-blue?logo=rsync)

> Manifest public de mon système Arch Linux. Objectif : stabilité, maîtrise, efficacité, philosophie KISS. Mise à jour : 2025-06-05

---

## 🧐 Vision

* Distribution : **Arch Linux** (rolling, minimal, KISS)
* Environnement : **Hyprland** (Wayland, moderne, customisable)
* Shell : `zsh` avec `oh-my-zsh` et `starship`
* Navigateur : **LibreWolf** (DoH vers LibreDNS, vie privée max)
* Pas de **Flatpak/Snap** (bloat interdit)
* Objectif : système **léger, contrôlé, documenté, réversible**

---

## 🛡️ Sécurité

* **IPv6 désactivé**
* **WireGuard** actif (tunnel vers serveur, split routing)
* **DNS** : LibreDNS (`116.202.176.26`) en DoH et système
* **UFW** actif : `deny incoming`, `allow outgoing`, port 22 ouvert (SSH)
* **auditd** actif
* **sudo** protégé (pas de `NOPASSWD`)
* **firejail** et **sandboxing** à l'étude
* Scripts d'audit : `audit_network.sh`, `toggle_ipv6.sh`, etc.

---

## 📆 Maintenance & Nettoyage

* Script `arch-clean.sh` :

  * Supprime les paquets orphelins
  * Nettoie le cache pacman/yay
  * Supprime `.pacnew`, logs > 7j
  * Affiche erreurs critiques (journalctl)
* Services actifs : `auditd`, `ufw`, `systemd-timesyncd`, `fstrim.timer`
* Maintenance régulière manuelle via alias : `update`, `clean`, `backup`

---

## 🌐 Réseau & VPN

* Interface principale : `enp3s0` (IPv4 uniquement)
* Tunnel VPN : `wg0`, split routing uniquement vers le serveur
* DNS système : LibreDNS en dur dans `/etc/resolv.conf` + `chattr +i`
* DNS LibreWolf : DoH vers `https://libredns.gr/dns-query`
* `systemd-resolved` configuré proprement pour éviter tout fallback

---

## 📁 Dotfiles & Config

* Gestion via **Git bare repo** : `~/.dotfiles`
* Dotfiles versionnés : `~/.zshrc`, `~/.config/hypr/`, `~/.config/xplr/`, `~/scripts/`,`~/.config/fastfetch`,`~/.config/kitty`
* Scripts utiles : `toggle_ipv6.sh`, `audit_network.sh`, `backup-home.sh`, etc.
* ZDOTDIR personnalisé dans `.zprofile`

---

## 📃 Sauvegarde & Restauration

* Sauvegarde perso via `rsync` vers `/backup/`
* Script `backup-home.sh` → loggé dans `~/.cache/backup.log`
* Restauration paquets via `pkglist.txt`
* Restauration dotfiles :

  ```bash
  git clone --bare <repo> ~/.dotfiles
  git --git-dir=~/.dotfiles --work-tree=~ checkout
  ```

---

## 🔍 Audit & Vérification

* Alias utiles :

  ```bash
  alias ipv6-off='~/scripts/toggle_ipv6.sh off'
  alias ipv6-on='~/scripts/toggle_ipv6.sh on'
  alias audit-net='~/scripts/audit_network.sh'
  alias dnscheck='resolvectl status | grep Current'
  alias myip='curl ifconfig.me'
  alias wgstatus='sudo wg show'
  ```

* Audit hebdo manuel recommandé : `audit-net && clean`

---

## 📈 Philosophie

* Tout changement est documenté et versionné
* Aucune techno sans audit et raison valable
* Minimalisme != privation → Juste ce qu'il faut, **bien configuré**
* ⚡ Performance, 🔒 Sécurité, ✨ Lisibilité, ♻ Reproductibilité

---

## 📊 Ressources utiles

* [https://wiki.archlinux.org](https://wiki.archlinux.org)
* [https://wiki.hyprland.org](https://wiki.hyprland.org)
* [https://libredns.gr](https://libredns.gr)
* [https://wireguard.com](https://wireguard.com)
* [https://aur.archlinux.org](https://aur.archlinux.org)
* [https://archlinux.org/news](https://archlinux.org/news)

---

> Document versionné. Mettre à jour à chaque évolution matérielle ou logicielle.

