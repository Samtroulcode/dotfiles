# 🧭 Plan d'action "ModernKISS"

## 🎯 Objectif final

Un système Arch Linux moderne, rapide, sans surcouche inutile. Minimaliste, mais pas austère.

### 🧱 Base système

- Arch Linux
- Hyprland (WM Wayland)
- PipeWire + WirePlumber (audio + screenshare)
- Kitty ou Foot (terminal GPU)
- rsync + Git bare (sauvegarde / dotfiles)
- nftables + VPN WireGuard (sécurité + tunnel)
- Partition : `/`, `/home`, `/swap`, `/backup`

---

## 🧰 Outils et apps

| Fonction              | Choix recommandé         |
|----------------------|--------------------------|
| Terminal              | Kitty / Foot             |
| Navigateur sécurisé   | Firefox                  |
| Chat Discord          | Vesktop                  |
| Musique               | Spotify-player / MPV     |
| Dév Neovim            | LazyVim + LSP            |
| Gaming                | Steam + Gamemode      |

---

## 🔄 Sauvegarde

- 🧠 Dotfiles : Git bare
- 💾 Fichiers : rsync vers `/backup/home-sam/`
- 🧩 Paquets :

```bash
pacman -Qqe > ~/backup/pkglist.txt
pacman -Qqm > ~/backup/aurlist.txt
```

---

## ⚙️ Post-installation

1. Maj complète : `sudo pacman -Syu`
2. Création utilisateur
3. Install micro setup `paru`, `btop`, `kitty`, etc.
4. Setup de `/etc/locale.gen`, `hostnamectl`, `timedatectl`
5. Git bare + restore dotfiles
6. Restauration fichiers via `rsync`
7. Restauration paquets :

```bash
sudo pacman -Syu --needed - < pkglist.txt
yay -S --needed - < aurlist.txt
```

---

## 🧪 Audit post-install

- `journalctl -p 3 -xb` → erreurs critiques
- `systemctl status` → services KO ?
- `systemd-analyze` → temps de boot
- `systemctl --user --failed`

---

## 🧼 Optimisation KISS

- Script clean hebdo
- `pacdiff` + `.pacnew` hook
- Aliases cohérents
- Trim SSD actif
- Sauvegarde régulière

---

## 🔐 Sécurité

- Pas de `NOPASSWD`
- Pare-feu actif
- Aucun service non utilisé activé
- Audit via `lynis`

---

## 🚀 Gaming

- Gamescope + MangoHud
- Combinés :

```bash
gamescope -f -- gamemoderun mangohud %command%
```

---

## 📌 Notes

- Attention au screenshare sur Webcord : bug `xdg-desktop-portal` → voir `flatpak_webcord.md`
