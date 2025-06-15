# 🎮 Optimisation Gaming sous Arch + Hyprland

## 🧱 Environnement requis

- Arch Linux
- GPU NVIDIA (via `nvidia-dkms`)
- PipeWire + WirePlumber
- Hyprland (Wayland)
- Steam en mode Proton (gaming)
- MangoHud (HUD performance)
- Gamescope (sandboxing + perf)
- Gamemode (optimisation CPU/IO)

---

## 🔥 Gamemode

Améliore la priorité CPU + inhibition du screensaver + gouverneur perf

### Commande simple

```bash
gamemoderun %command%
```

### Installation

```bash
sudo pacman -S gamemode
```

---

## 📊 MangoHud

Affiche les FPS, usage CPU/GPU/RAM, etc.

### Commande simple

```bash
gamemoderun mangohud %command%
```

### Fichier de config

`~/.config/MangoHud/MangoHud.conf`  
→ personnaliser les métriques visibles

---

## 🧱 Gamescope

Permet :

- Sandboxing de jeu (résolution, perf, input)
- Tiling propre sous Hyprland
- Compatible avec Proton

### Commande complète

```bash
gamescope -f -- gamemoderun mangohud %command%
```

- `-f` : fullscreen
- `--` : séparation args
- `%command%` : utilisé par Steam

---

## 🧪 Utilitaire Steam

Dans les options de lancement du jeu :

```bash
gamescope -f -- gamemoderun mangohud %command%
```

### Alternative résolution

```bash
gamescope -w 1280 -h 720 -f -- gamemoderun %command%
```

---

## 🚀 Autres outils

- `btop` → pour monitoring CPU/GPU
- `nvidia-smi` → vérifie usage NVIDIA
- `hyprctl` → inspecte FPS/taux de frames si supporté

---

## 🧠 Bonnes pratiques

- Vérification sur protondb pour la compatibilité
- Lance Steam via `gamescope` si bug input
- Active Proton 8.0+
- Précharge shader Steam
- Évite `xwaylandvideobridge` si pas nécessaire
- Teste le jeu seul, sans Discord/Spotify en arrière-plan
- Retour d'expérience sur protondb
