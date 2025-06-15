# Partitions, Fstab, Swap et Sauvegardes (KISS)

## 📁 Structure de partition recommandée
Utiliser `lsblk -f` pour vérifier :
- `/`, `/home`, `/boot`, `/backup` bien séparés
- UUIDs dans `/etc/fstab` (pas de noms de device type `/dev/sdX`)

Vérification :
```bash
bat /etc/fstab
```

## 🔁 SWAP File (au lieu de partition)
Créer un swap file de 2 Go :
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

Activer dans fstab :
```fstab
/swapfile none swap defaults 0 0
```

Vérification :
```bash
swapon --show
```

## ✂️ TRIM SSD
Maintient les performances de ton SSD

Activer :
```bash
sudo systemctl enable --now fstrim.timer
```

Vérifier :
```bash
systemctl status fstrim.timer
systemctl list-timers | grep fstrim
```

Exécuter manuellement :
```bash
sudo fstrim -av
```

## 💾 Sauvegarde avec rsync

Sauvegarde :
```bash
rsync -avh --delete /home/sam/ /backup/home-sam/
```

Explication :
- `-a` : mode archive
- `-v` : verbose
- `-h` : human readable
- `--delete` : supprime les fichiers supprimés dans la source

Restauration partielle :
```bash
cp /backup/home-sam/Documents/rapport.txt ~/Documents
```

Restauration complète :
```bash
rsync -a /backup/home-sam/ /mnt/home/sam/
```

Bonnes pratiques :
- Sauvegarder juste après `pacman -Syu`
- Snapshot avant actions risquées

