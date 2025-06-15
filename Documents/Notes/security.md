# Sécurité du système Arch (KISS-compatible)

## 🔐 Sudo & Root
- Pas d’autologin root
- Pas de `NOPASSWD` dans sudoers :
```bash
grep -E 'NOPASSWD|ALL' /etc/sudoers /etc/sudoers.d/* 2>/dev/null
```

## 🔥 Pare-feu
- UFW (simplicité KISS) ou `nftables`
- Vérifier état :
```bash
sudo ufw status
```

## 🛡️ Audits de sécurité
- Outil recommandé : `lynis`
```bash
sudo lynis audit system
```

## 🧠 Services & supervision
- Vérifier services actifs :
```bash
systemctl list-unit-files --state=enabled
```

- Vérifier services utilisateur :
```bash
systemctl --user --failed
```

## 🗂️ Sauvegardes
- Ne jamais faire de grosses MAJ sans sauvegarde
- Toujours avoir :
  - Sauvegarde des paquets (`pacman -Qqe`, `pacman -Qqm`)
  - Dotfiles versionnés
  - Données utilisateur via rsync (voir `backup_dotfiles.md`)

