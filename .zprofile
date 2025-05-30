# Priorité aux scripts et binaires locaux
export PATH="$HOME/scripts:$HOME/.local/bin:$PATH"

# Forcer zsh login interactif sur TTY 1 (ex: sans display manager)
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec zsh -l

# Forcage de plasma wayland
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startplasma-wayland
