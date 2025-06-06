# 📘 Neovim Cheatsheet – Débutant

## 🧭 Modes
- `i` → mode **insertion**
- `Esc` → retour au **mode normal**
- `v` → **sélection** caractère par caractère
- `V` → sélection **ligne entière**
- `Ctrl-v` → sélection **colonne (visuel bloc)**

---

## 💾 Sauvegarde et sortie
| Commande | Description              |
|----------|--------------------------|
| `:w`     | sauvegarder              |
| `:q`     | quitter                  |
| `:wq`    | sauver + quitter         |
| `:q!`    | forcer à quitter sans save |
| `ZZ`     | sauver + quitter (rapide) |

---

## 🧍 Navigation
| Touche   | Action                        |
|----------|-------------------------------|
| `h j k l`| gauche, bas, haut, droite     |
| `w`      | mot suivant                   |
| `b`      | mot précédent                 |
| `0`      | début de ligne                |
| `^`      | premier caractère non vide    |
| `$`      | fin de ligne                  |
| `gg`     | début du fichier              |
| `G`      | fin du fichier                |

---

## ✂️ Édition
| Commande | Description            |
|----------|------------------------|
| `x`      | supprimer caractère    |
| `dd`     | supprimer une ligne    |
| `yy`     | copier une ligne       |
| `p`      | coller après le curseur|
| `u`      | annuler                |
| `Ctrl-r` | refaire                |
| `r<car>` | remplacer caractère    |

---

## 🔍 Recherche
| Commande   | Description                   |
|------------|-------------------------------|
| `/mot`     | chercher vers le bas          |
| `?mot`     | chercher vers le haut         |
| `n`        | occurrence suivante           |
| `N`        | occurrence précédente         |

---

## 🖼️ Visualisation
| Commande     | Description                      |
|--------------|----------------------------------|
| `:set number`| numéro de ligne                  |
| `:set rnu`   | numérotation relative            |
| `:set mouse=a`| activer la souris               |
| `:syntax on` | coloration syntaxique            |

---

## 🪟 Fenêtres & fichiers
| Commande     | Description                      |
|--------------|----------------------------------|
| `:vsp`       | split vertical                   |
| `:sp`        | split horizontal                 |
| `:e <file>`  | ouvrir un fichier                |
| `:bn / :bp`  | buffer suivant / précédent       |
| `:bd`        | fermer le buffer courant         |
| `Ctrl-w` + `h/j/k/l` | bouger entre splits      |

---

## 🔧 Configuration minimaliste (init.vim)
À mettre dans `~/.config/nvim/init.vim` :
```vim
set number
set relativenumber
set mouse=a
syntax on
set clipboard=unnamedplus

