# Mise à jour système (KISS)

## Philosophie

- KISS : simplicité et efficacité avec `pacman -Syu`
- Alias recommandés :
  - `update` → `sudo pacman -Syu`
  - `archnews` → `lynx https://archlinux.org/news/`

## Commandes clés

1. `pacman -Syu` : synchroniser et mettre à jour paquets (incl. AUR)
2. Reboot après mise à jour du kernel/systemd/glibc
3. Lire les breaking changes sur le site ou via `archnews`

## Script de maintenance (`arch‑clean.sh`)

- Structure :

  ```bash
  sudo pacman -Syu
  pacman -Rns $(pacman -Qtdq)
  sudo paccache -rk2 && sudo paccache -ruk0
  sudo journalctl --vacuum-time=7d
  journalctl -p 3 -xb -n 10
  
- Versionné dans Git bare : /script/arch-clean.sh
