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
