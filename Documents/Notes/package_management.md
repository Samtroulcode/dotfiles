# Gestion des paquets (Pacman & AUR)

## Installation et mise à jour
- `sudo pacman -Syu <paquet>` : synchroniser + installer un paquet
- Alias pratique : `update` → `sudo pacman -Syu`

## Liste des paquets
- `pacman -Qe`  
  → Liste des paquets installés explicitement (*alias* : `installed`)
- `pacman -Qm`  
  → Liste des paquets AUR (*alias* : `installedAur`)

## Désinstallation
```bash
sudo pacman -Rns <paquet>
```
- `-R` : suppression du paquet
- `-n` : supprime les fichiers de conf
- `-s` : supprime les dépendances inutiles

## Audit des paquets
- `pacman -Qi [<paquet>]`  
  → Info et poids du paquet
- `pacman -Qq`  
  → Liste minimaliste pour tri/filtre
- `pacman -Qqe | grep kde`  
  → Recherche de paquets KDE explicitement installés
- `pacstats` (script perso)  
  → Audit complet local + AUR

## AUR & PKGBUILD
- Utilisation manuelle avec `makepkg` ou via helper (`yay` ou `paru`)
- Toujours vérifier le PKGBUILD avant installation
- Nettoyer dépendances orphelines AUR :
```bash
yay -Qtdq | xargs sudo pacman -Rns
```

## .pacnew
Lors d'une mise à jour qui modifie un fichier de `/etc`, un `.pacnew` est généré :
- Pour vérifier :
```bash
sudo pacdiff
```
(install de `pacman-contrib` requis)

### Solution proactive :
- Ajouter un hook dans `/etc/pacman.d/hooks/pacnew-check.hook` pour signaler automatiquement les fichiers `.pacnew`


