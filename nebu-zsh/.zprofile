# Priorité aux scripts et binaires locaux
export PATH="$HOME/scripts:$HOME/.local/bin:$PATH"

[[ "$(tty)" == "/dev/tty1" ]] && exec uwsm start default
# if [[ "$(tty)" == "/dev/tty1" ]] && uwsm check may-start && uwsm select; then
#   exec uwsm start default
# fi

export GTK_THEME=Kanagawa-Yellow-Dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
export GDK_BACKEND=wayland

# Pour zk
export ZK_NOTEBOOK_DIR="$HOME/Documents/Notes"

# Pour que Steam tourne en Wayland avec la couche XWayland
export SDL_VIDEODRIVER=wayland
export GDK_BACKEND=wayland,x11
export QT_QPA_PLATFORM='wayland;xcb'

# Pour forcer l'accélération GPU NVIDIA avec XWayland
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __GL_VRR_ALLOWED=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export __NV_PRIME_RENDER_OFFLOAD=1
export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
