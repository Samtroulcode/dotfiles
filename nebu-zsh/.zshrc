# PATH propre et dédupliqué
typeset -U path PATH
path=("$HOME/scripts" "$HOME/.local/bin" "$HOME/bin" "/usr/local/bin" "$HOME/bin/mpv-tools/TOOLS" $path)

export LANG=fr_FR.UTF-8

setopt complete_aliases

# omz
export ZSH="$HOME/.oh-my-zsh"
plugins=(git sudo common-aliases colored-man-pages)
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # Autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Syntax highlighting
source /usr/share/wikiman/widgets/widget.zsh # Ctrl+F pour chercher dans le wikiman

# opencode
export PATH=/home/sam/.opencode/bin:$PATH

# backlog
fpath=(/home/sam/.zsh/completions $fpath)

# autocompletion eza
compdef _eza ls

# Setup des keybinds pour fzf
source <(fzf --zsh)

# NVIM
export NVIM="$HOME/.config/nvim"

# Completion cache
: "${XDG_CACHE_HOME:=$HOME/.cache}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# Historique costaud et propre
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt inc_append_history hist_verify hist_ignore_all_dups hist_reduce_blanks
setopt hist_ignore_space hist_expire_dups_first

# UX & ergonomie
stty -ixon # libère Ctrl+S/Ctrl+Q (flow control off)
KEYTIMEOUT=1 # réduit la latence après Échap (vi/esc-bindings + rapides)
setopt interactivecomments extendedglob # autorise les # en interactif

# vim en editeur par défaut
export EDITOR=nvim
export VISUAL=nvim

# Nvim en tant que man pager
export MANPAGER='nvim +Man!'

# Aliases modernes
[[ -f ~/.zsh/modern-commands.zsh ]] && source ~/.zsh/modern-commands.zsh

# Aliases généraux
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# Aliases de snapshot
[[ -f ~/.zsh/snapper.zsh ]] && source ~/.zsh/snapper.zsh

# Aliases/Commandes Nvim
[[ -f ~/.zsh/nvim.zsh ]] && source ~/.zsh/nvim.zsh

# Commandes custom
[[ -f ~/.zsh/custom/spf.zsh ]] && source ~/.zsh/custom/spf.zsh # spf cd on quit
[[ -f ~/.zsh/custom/cleantmp.zsh ]] && source ~/.zsh/custom/cleantmp.zsh # petit clean de logs, tmp et bak
[[ -f ~/.zsh/custom/detach.zsh ]] && source ~/.zsh/custom/detach.zsh # pour détacher complétement un process du shell
[[ -f ~/.zsh/custom/tmux.zsh ]] && source ~/.zsh/custom/tmux.zsh # Aliases et fonctions tmux

# Commandes fzf
[[ -f ~/.zsh/fzf/fzf-movie.zsh ]] && source ~/.zsh/fzf/fzf-movie.zsh # picker fzf pour les films du servarr
[[ -f ~/.zsh/fzf/fzf-aliases.zsh ]] && source ~/.zsh/fzf/fzf-aliases.zsh # picker fzf pour les aliases
[[ -f ~/.zsh/fzf/fzf-files.zsh ]] && source ~/.zsh/fzf/fzf-files.zsh # picker fzf pour les fichiers

# Theme d'autocomplétion zsh
[[ -f ~/.zsh/themes/drac.zsh ]] && source ~/.zsh/themes/drac.zsh

# Affichage fastfetch uniquement si terminal interactif
if [[ $- == *i* ]] && [[ -t 1 ]]; then
    fastfetch --kitty-icat ~/.config/fastfetch/logo/arch-linux.png
fi

# Initialiser Starship prompt
eval "$(starship init zsh)"

# Initialiser zoxide
eval "$(zoxide init zsh)"

# Initialiser mcfly
eval "$(mcfly init zsh)"

_nrip_complete() {
  local cur prev cmd
  cur=${words[-1]}
  prev=${words[-2]}

  if [[ $prev == "-c" || $prev == "--cremate" ]]; then
    compadd -- ${(f)"$(nrip --__complete cremate "$cur")"}
    return 0
  elif [[ $prev == "-r" || $prev == "--resurrect" ]]; then
    compadd -- ${(f)"$(nrip --__complete resurrect "$cur")"}
    return 0
  fi
  return 1
}
compdef _nrip_complete nrip

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

