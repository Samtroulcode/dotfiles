
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
* GPU : NVIDIA GeForce RTX 3070
* Disques :

  * `/` : 29.36 GiB (ext4)
  * `/home` : 171.69 GiB (ext4)
* Mémoire : 15.53 GiB
* Swap : 4.00 GiB
* Affichage :

  * VSC36AF (24") 1920x1080 @ 144Hz \[HDMI-0]
  * LC27G5xT (32") 2560x1440 @ 144Hz \[DP-0]
* Adresse IP locale : <machine-ip-redacted>
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
* 🔍 Vérification régulière des permissions sudo :
  ```bash
  grep -RE 'NOPASSWD|ALL' /etc/sudoers /etc/sudoers.d/* 2>/dev/null
  ```

### 📌 Prévu

* 🔄 earlyoom à étudier (évite les freezes en cas de saturation mémoire)
  - Service léger basé sur swap/memory monitoring
  - Remplaçant simple de `oomd` pour desktop
  - Non encore installé

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

## 💽 Partitionnement (2025-05)

| Point de montage | Partition   | Taille  | FS   | Label  |
|------------------|-------------|---------|------|--------|
| /boot            | /dev/sdb5   | ~830M   | vfat |        |
| /                | /dev/sdb6   | ~29G    | ext4 | root   |
| /home            | /dev/sdb7   | ~171G   | ext4 | home   |
| /backup          | /dev/sdb8   | ~30G    | ext4 | backup |

---

## 🧠 Fichiers critiques à surveiller

```text
/home/<user>/.zshrc
/home/<user>/.zprofile
/home/<user>/.config/systemd/user/*
/home/<user>/scripts/*
/home/<user>/.local/bin/*
/home/<user>/.config/kwinrc
/home/<user>/.config/gtk-3.0/settings.ini
```

---

## 📂 Sauvegarde utilisateur

* Sauvegarde manuelle du dossier personnel via `rsync` :

  ```bash
  rsync -avh --delete /home/sam/ /backup/home-sam/
	```

* But : restauration fichiers utilisateur
* Scripté via : ~/scripts/backup-home.sh
* Loggé dans : ~/.cache/backup.log
* Lancement : manuel pour l’instant (alias backup)
* ⚠️ Pas encore de cron ou systemd.timer en place (prévu)
* Restaurable facilement via cp ou rsync inverse

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
* Script de nettoyage (`~/scripts/arch-clean.sh`) :
  - Fait partie des dotfiles (versionné)
  - Nettoie paquets orphelins, cache pacman/yay, `.pacnew`, logs > 7j
  - Vérifie erreurs critiques via `journalctl -p 3 -xb`
  - Vérifie les services en échec avec `systemctl --failed`
  - Affiche espace disque
  - Log : `~/.cache/arch-clean-<date>.log`
```markdown
* Fréquence recommandée :
  - Mise à jour système (`update`) tous les 2–3 jours
  - Audit visuel des erreurs (`clean`) une fois par semaine
  - Backup utilisateur (`backup`) manuellement après changements importants
```

---

## 🧾 Aliases système

* `update` → `sudo pacman -Syu`
* `orphanclean` → `pacman -Rns $(pacman -Qtdq)`
* `installed` → `pacman -Qe`
* `installedAur` → `pacman -Qm`
* `archnews` → `lynx https://archlinux.org/news/`
* `clean` → `~/scripts/arch-clean.sh | tee ~/.cache/arch-clean-$(date +%F_%H-%M).log`
* `backup` → `~/scripts/backup-home.sh`

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

### Vérifier intégrité des fichiers système (si nécessaire)
sudo pacman -Qk

sudo pacman -Syu --needed - < ~/backup/pkglist.txt

🔐 Activer services :

    systemctl enable auditd ufw systemd-timesyncd fstrim.timer

    📦 yay pour paquets AUR (si manquants)

    🔗 Restauration des fichiers système via rsync (si sinistre majeur)


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
/swapfile
```

---

## ✅ Bonnes pratiques appliquées

- ✔️ Pas de paquets inutiles installés
- ✔️ Aucun service non utilisé laissé actif
- ✔️ Dépôts AUR audités avant installation
- ✔️ Fichiers `.bak`, `.old`, `.desktop` nettoyés régulièrement
- ✔️ ZDOTDIR défini dans ~/.zprofile pour isoler et maîtriser la config zsh
- ✔️ Aucun fichier sensible ou chiffré dans `.dotfiles`

---

## 🧠 À ne pas oublier

- 🔁 Toujours tester un dotfile avant commit (shell de test possible avec `zsh -f`)
- 🛡️ Ne jamais faire confiance à un script externe sans audit préalable
- 🔄 Penser à re-sauvegarder `pkglist.txt` après ajout/suppression majeure
- ☁️ Garder une copie hors-ligne des `dotfiles` et du `rsync` complet (clé USB ou NAS)

---

## 📘 Références complémentaires

- [ARCH_MEMO.md](./ARCH_MEMO.md) – notes pratiques, commandes et bonnes pratiques d’administration quotidienne

---

## 📚 Ressources

> https://wiki.archlinux.org

> https://archlinux.org/news

> https://archlinux.org/packages

---

## 🧾 Notes

> Ce fichier est versionné dans `.dotfiles`, et doit être mis à jour à chaque changement de politique ou d'outil.
