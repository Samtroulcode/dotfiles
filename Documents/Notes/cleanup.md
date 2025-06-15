# Nettoyage régulier (KISS)

## Objectif
Garder un système propre, performant et à jour, sans accumuler de paquets orphelins, de logs inutiles ou de caches dépassés.

---

## 🔍 Paquets orphelins

```bash
pacman -Qdtq
```
    -Q : interroge la base

    -d : dépendances non requises

    -t : installés comme dépendance

    -q : sortie simplifiée

Suppression :

```bash
sudo pacman -Rns $(pacman -Qtdq)
```
➡️ Alias : orphanclean
🗑️ Nettoyage du cache

```bash
sudo paccache -rk2
sudo paccache -ruk0
```

    Garde 2 versions installées

    Supprime les paquets orphelins non installés

🧾 Logs système

journalctl -p 3 -xb -n 10

➡️ Voir les erreurs critiques du système

Limiter la taille du journal :

# /etc/systemd/journald.conf
SystemMaxUse=100M

🧠 Fusion des fichiers .pacnew

sudo DIFFPROG="nvim -d" pacdiff

➡️ Nécessite : sudo pacman -S pacman-contrib
🧹 Script clean complet

Nom : arch-clean.sh (versionné dans dotfiles)

sudo pacman -Syu
pacman -Rns $(pacman -Qtdq)
sudo paccache -rk2 && sudo paccache -ruk0
sudo journalctl --vacuum-time=7d
journalctl -p 3 -xb -n 10

🖥️ Outils visuels

    htop ou btop pour la surveillance système


---

✅ Une fois le fichier enregistré, tu peux le retrouver via :

```vim
:Telekasten find_notes

et choisir cleanup.md
