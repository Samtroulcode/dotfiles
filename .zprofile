# Priorité aux scripts et binaires locaux
export PATH="$HOME/scripts:$HOME/.local/bin:$PATH"

# Lancer Hyprland si tty1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec Hyprland
fi

# Forcer zsh login interactif sur TTY 1 (ex: sans display manager)
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec zsh -l

export GTK_THEME=Adwaita-dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
export GDK_BACKEND=wayland

# Pour que Steam tourne en Wayland avec la couche XWayland
export SDL_VIDEODRIVER=wayland
export GDK_BACKEND=wayland,x11
export QT_QPA_PLATFORM=wayland;xcb

# Pour forcer l'accélération GPU NVIDIA avec XWayland
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __GL_VRR_ALLOWED=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export __NV_PRIME_RENDER_OFFLOAD=1
export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
