# ZSH minimal, rapide, moderne

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Powerlevel10k prompt instantané (chargement ultra rapide)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Aliases modernes 
[[ -f ~/.zsh/modern-commands.zsh ]] && source ~/.zsh/modern-commands.zsh

# Aliases généraux
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# Aliases scripté

plugins=(git sudo common-aliases colored-man-pages)
source $ZSH/oh-my-zsh.sh

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# PATH utilisateur en priorité
export PATH="$HOME/scripts:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

export LANG=fr_FR.UTF-8

# Historique optimisé
setopt inc_append_history share_history hist_verify
setopt hist_ignore_all_dups hist_reduce_blanks

# Git
if command -v git &> /dev/null; then
  alias g='git'
  alias gs='git status'
  alias ga='git add'
  alias gc='git commit -m'
  alias gp='git push'
  alias gl='git log --oneline --graph --decorate --all'
fi

# Pour les "BEEP" du terminal
# setopt BEEP

# Fix Tilix
if [ "$TILIX_ID" ] || [ "$VTE_VERSION" ]; then
  source /etc/profile.d/vte.sh
fi

# Pour les beep du terminal
#beep() {
#  play -n synth 0.1 sin 1000 > /dev/null 2>&1
#}
beep() {
  command -v play &>/dev/null && play -n synth 0.1 sin 1000 > /dev/null 2>&1
}
bindkey "^G" beep

# Affichage fastfetch uniquement si terminal interactif
if [[ $- == *i* ]] && [[ -t 1 ]]; then
  fastfetch
fi

# zoxide (autojump moderne)
cd() {
  if [[ $# -eq 0 || "$1" == "-" || "$1" == "." || "$1" == ".." || "$1" == /* || -d "$1" ]]; then
    builtin cd "$@"
  else
    zoxide cd "$@"
  fi
}
