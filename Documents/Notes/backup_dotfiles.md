# 🔄 Sauvegarde des Dotfiles avec Git bare + rsync

## 📦 Pourquoi Git bare ?

- Pas de dossier `.git` dans chaque config
- Ne pollue pas le `$HOME`
- Peut être versionné, synchronisé, restauré en une ligne

---

## ⚙️ Initialisation Git bare

```bash
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Empêcher les fichiers non trackés d’apparaître :

```bash
config config --local status.showUntrackedFiles no
```

---

## 🧑‍💻 Utilisation quotidienne

```bash
config status
config diff ~/.zshrc
config add ~/.zshrc
config commit -m "fix: ajout plugin zsh"
config push
```

➡️ **Évite les `-a` !** (ajoute tous les fichiers non ignorés)

---

## 🚀 Restauration sur un autre système

```bash
git clone --bare git@github.com:USERNAME/dotfiles.git $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config checkout
config config --local status.showUntrackedFiles no
```

---

## 🔁 Restauration ciblée

### Revenir à un état antérieur global

```bash
config checkout <commit_hash>
```

### Revenir à un fichier spécifique

```bash
config log -- path/to/file
config checkout <commit_hash> -- path/to/file
```

---

## ✅ Bonnes pratiques Git

| Action                        | Bonne pratique ? | Détail                                         |
|------------------------------|------------------|------------------------------------------------|
| Un commit par fichier        | ❌ Too much       | Trop verbeux                                   |
| Un commit par lot cohérent   | ✅ Recommandé     | Regrouper par thème (aliases, shell, etc.)     |
| Push après test              | ✅ Indispensable  | Ne jamais push des confs cassées               |
| Branches de test             | ✔️ Optionnel      | `config checkout -b test-zsh`                  |

---

## 📚 Suffixes de commit

- `feat:` → nouvelle fonctionnalité
- `fix:` → correction de bug
- `refactor:` → réécriture sans changement de comportement
- `docs:` → documentation
- `style:` → indentation, mise en forme
- `chore:` → maintenance / nettoyage
