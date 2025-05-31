
# 🏩 ARCH\_MANIFEST.md

![Arch](https://img.shields.io/badge/arch-linux-blue?logo=arch-linux&logoColor=white)
![Zsh](https://img.shields.io/badge/shell-zsh-4EAA25?logo=gnu-bash&logoColor=white)
![KISS](https://img.shields.io/badge/philosophie-KISS-9cf)
![NoFlatpak](https://img.shields.io/badge/NO-snap/flatpak-red)
![Dotfiles](https://img.shields.io/badge/dotfiles-git--bare-orange)
![Wayland](https://img.shields.io/badge/Wayland-enabled-success?logo=wayland)
![ufw](https://img.shields.io/badge/firewall-ufw-critical?logo=ubuntu)
![rsync](https://img.shields.io/badge/backup-rsync-blue?logo=rsync)

> Manifest système Arch Linux — Vision : stabilité, simplicité pragmatique, maintenabilité, sécurité, modernité raisonnée, documentation Version : 2025-05-30

---

## 🧭 Vision système

- Système Arch Linux pur, rolling-release, minimal et maîtrisé
- Interface moderne et fonctionnelle : KDE Plasma sous Wayland
- Priorité à la stabilité, la maintenabilité et la sécurité
- Système KISS **pragmatique** : on évite la complexité gratuite, mais on accepte la modernité quand elle est justifiée
- Paquets et services audités, aucune surcouche non comprise ou non justifiée
- Flatpak/Snap **interdits par défaut**, mais tolérés **si audités et nécessaires**
- Composants KDE réduits au minimum utile, aucun groupe `kde-*` installé tel quel


---

## 💥 Matériel et environnement actuel

* Processeur : AMD Ryzen 5 3600 (12 threads) @ 4.21 GHz
* GPU : NVIDIA GeForce RTX 3070 (drivers propriétaires)
* Disques :

  * `/` : 29.36 GiB (ext4), utilisé : 14.02 GiB (48%)
  * `/home` : 171.69 GiB (ext4), utilisé : 2.32 GiB (1%)
* Mémoire : 5.93 GiB / 15.53 GiB (38%)
* Swap : 4.00 GiB (0% utilisé)
* Affichage :

  * VSC36AF (24") 1920x1080 @ 144Hz \[HDMI-0]
  * LC27G5xT (32") 2560x1440 @ 144Hz \[DP-0] ⭐ actif
* Adresse IP locale : 192.168.1.177/24 (interface enp3s0)
* Locale : `fr_FR.UTF-8`

---

## 🔐 Sécurité

* 🔥 `ufw` actif, avec règles strictes
* 🕵️ `auditd` actif
* 🔒 `sudo` ne doit **jamais** contenir de `NOPASSWD`
* ⏱️ `systemd-timesyncd` actif pour synchro NTP
* 🧹 `fstrim.timer` actif pour TRIM des SSD
* 🔐 `pam` surveillé et conforme
* 🔍 Commande d’audit : `journalctl -p 3 -xb`

---

## 📦 Gestion des paquets

* `pacman` uniquement pour les paquets officiels
* `yay` utilisé avec modération (aucun paquet inutile, AUR audité)
* Paquets AUR installés : `yay`, `librewolf-bin`, `librewolf-bin-debug`, `webcord`
* Paquets installés sauvegardés via :

  ```bash
  pacman -Qqe > ~/backup/pkglist.txt
  ```
* Restauration propre :

  ```bash
  sudo pacman -Syu --needed - < pkglist.txt
  ```
* Aucun nettoyage automatique des paquets non listés dans `pkglist.txt`
* Refus des snap / flatpak / appimage

---

## 🗂️ Dotfiles & configuration

* Gestion des fichiers de config via :

  ```bash
  alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
  ```
### Dotfiles versionnés (liste à maintenir et à amélioré)

- `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh`
- `~/.xinitrc`
- `~/.zsh/` (modules)
- `~/.local/bin/` (scripts CLI)
- `~/scripts/` (maintenance, audit)
- `~/.config/systemd/user/` (timers et services)
- `ARCH_MANIFEST.md` ✅

* Commit propres, lisibles, versionnés par fonctionnalité

---

## 📁 Arborescence

> Gérée automatiquement par dotfiles, scripts et sauvegardes rsync. Voir :
> - `~/backup/` pour les listes de paquets
> - `~/scripts/` pour les scripts d’audit et de maintenance
> - `~/.dotfiles` (git bare) pour les dotfiles versionnés

---

## 🧠 Fichiers critiques à surveiller

```text
/home/sam/.zshrc
/home/sam/.zprofile
/home/sam/.config/systemd/user/*
/home/sam/scripts/*
/home/sam/.local/bin/*
/home/sam/.config/kwinrc
/home/sam/.config/gtk-3.0/settings.ini
```

---

## 🔄 Sauvegarde système

* Sauvegarde via `rsync` :

  ```bash
  rsync -aAXHv --delete --exclude-from=/etc/rsync/exclude.txt / /mnt/backup
  ```
* Exclusions : `/dev`, `/proc`, `/sys`, `/run`, `/tmp`, `/mnt`, `/media`, `/lost+found`
* But : restauration complète post-sinistre

---

## 🌐 Réseau & VPN

* VPN principal : WireGuard (client)
* Tunnel VPN via configuration manuelle propre dans `/etc/wireguard/*.conf`
* Aucun impact sur les autres services

---

## 🧼 Maintenance régulière

* Vérification des paquets orphelins :

  ```bash
  pacman -Qdt
  ```
* Vérification des erreurs système :

  ```bash
  journalctl -p 3 -xb
  ```
* Vérification du `trim` :

  ```bash
  systemctl status fstrim.timer
  ```
* Timers actifs : `systemd-tmpfiles-clean.timer`, `shadow.timer`, `fstrim.timer`, `archlinux-keyring-wkd-sync.timer`
* Services actifs : auditd, NetworkManager, nvidia suspend/resume, ufw, systemd-timesyncd
* Services utilisateur : wireplumber, pipewire, pipewire-pulse, xdg user dirs, p11-kit

---

## ❌ Interdits

* Aucun environnement secondaire installé (pas de GNOME, XFCE, etc.)
* Aucun service résiduel non utilisé (désactivation via `systemctl`)
* Aucun fichier temporaire ou `.bak` traînant
* Pas de `.desktop` inutiles dans `~/.config/autostart`
* Pas de logiciel non versionné ou non explicite ici

---

## 🧪 Audit à automatiser (à venir)

🔎 AppArmor non installé (choix de simplicité), à considérer si besoin d'isolation renforcée.

Lynis comme outil d’audit recommandé

Créer un script `~/.local/bin/audit_arch.sh` pour vérifier :

* erreurs critiques (`journalctl -p 3 -xb`)
* services activés au boot (`systemctl list-unit-files | grep enabled`)
* timers actifs (`systemctl list-timers`)
* paquets orphelins
* paquets non listés dans `pkglist.txt`
* fichiers non versionnés
* services systemd --user actifs

---

## 🔄 Restauration système complète (checklist)

1. ⬇️ Cloner dotfiles :
   ```bash
   git clone --bare git@github.com:DuarteAd/dotfiles.git $HOME/.dotfiles
   git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

    🐚 Activer le shell :

chsh -s /bin/zsh

🔄 Restauration paquets :

# Vérifier intégrité des fichiers système (si nécessaire)
sudo pacman -Qk

sudo pacman -Syu --needed - < ~/backup/pkglist.txt

🔐 Activer services :

    systemctl enable auditd ufw systemd-timesyncd fstrim.timer

    📦 yay pour paquets AUR (si manquants)

    🔗 Restauration des fichiers système via rsync (si sinistre majeur)


---

### 📁 `rsync` – fichier d’exclusion recommandé
`exclude.txt`

```bash
# /etc/rsync/exclude.txt
/dev/*
/proc/*
/sys/*
/tmp/*
/run/*
/mnt/*
/media/*
/lost+found
/home/*/.cache/
/home/*/.local/share/Trash/
/swapfil
```

## ✅ Bonnes pratiques appliquées

- ✔️ Pas de paquets inutiles installés
- ✔️ Aucun service non utilisé laissé actif
- ✔️ Dépôts AUR audités avant installation
- ✔️ Fichiers `.bak`, `.old`, `.desktop` nettoyés régulièrement
- ✔️ ZDOTDIR défini pour cohérence de chargement zsh
- ✔️ Aucun fichier sensible ou chiffré dans `.dotfiles`

## 🧠 À ne pas oublier

- 🔁 Toujours tester un dotfile avant commit (shell de test possible avec `zsh -f`)
- 🛡️ Ne jamais faire confiance à un script externe sans audit préalable
- 🔄 Penser à re-sauvegarder `pkglist.txt` après ajout/suppression majeure
- ☁️ Garder une copie hors-ligne des `dotfiles` et du `rsync` complet (clé USB ou NAS)

## 📚 Ressources

> https://wiki.archlinux.org

> https://archlinux.org/news

> https://archlinux.org/packages

## 🧾 Notes

> Ce fichier est versionné dans `.dotfiles`, et doit être mis à jour à chaque changement de politique ou d'outil.
