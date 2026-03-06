# Optional vi-mode setup (not sourced by default).
#
# To enable: source this file from a module in ~/.zsh/init/

# # Activation du mode vi
# bindkey -v
#
# # Historique "par prefixe" sur j/k en mode Normal
# autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
# bindkey -M vicmd 'k' up-line-or-beginning-search
# bindkey -M vicmd 'j' down-line-or-beginning-search
#
# # Curseur bloc en Normal, barre en Insert (Ghostty/Kitty/Alacritty OK)
# function zle-keymap-select {
#   if [[ $KEYMAP == vicmd ]]; then
#     print -n '\e[2 q'   # bloc
#   else
#     print -n '\e[6 q'   # barre
#   fi
#   zle reset-prompt
# }
# function zle-line-init {
#   zle -K viins
#   print -n '\e[6 q'
# }
# zle -N zle-keymap-select
# zle -N zle-line-init
