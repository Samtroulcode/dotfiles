# ZSH minimal, rapide, moderne


# PATH propre et dédupliqué
typeset -U path PATH
path=("$HOME/scripts" "$HOME/.local/bin" "$HOME/bin" "/usr/local/bin" "$HOME/bin/mpv-tools/TOOLS" $path)

export LANG=fr_FR.UTF-8

# omz
export ZSH="$HOME/.oh-my-zsh"
plugins=(git sudo common-aliases colored-man-pages)
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # Autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Syntax highlighting

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

# Aliases modernes 
[[ -f ~/.zsh/modern-commands.zsh ]] && source ~/.zsh/modern-commands.zsh

# Aliases généraux
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# Aliases de snapshot
[[ -f ~/.zsh/snapper.zsh ]] && source ~/.zsh/snapper.zsh

# Commandes custom
[[ -f ~/.zsh/custom/spf.zsh ]] && source ~/.zsh/custom/spf.zsh # spf cd on quit
[[ -f ~/.zsh/custom/cleantmp.zsh ]] && source ~/.zsh/custom/cleantmp.zsh # petit clean de logs, tmp et bak
[[ -f ~/.zsh/custom/detach.zsh ]] && source ~/.zsh/custom/detach.zsh # pour détacher complétement un process du shell

# Theme d'autocomplétion zsh
[[ -f ~/.zsh/themes/drac.zsh ]] && source ~/.zsh/themes/drac.zsh

# Affichage neofetch uniquement si terminal interactif
if [[ $- == *i* ]] && [[ -t 1 ]]; then
  neofetch
fi

# Initialiser Starship prompt
eval "$(starship init zsh)"

# Initialiser zoxide
eval "$(zoxide init zsh)"

# Initialiser mcfly
eval "$(mcfly init zsh)"

