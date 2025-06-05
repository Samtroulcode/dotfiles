# ~/.zsh/modern-commands.zsh
# Alias vers les commandes modernes, sans écraser les commandes classiques

# Chargement uniquement en shell interactif
if [[ $- == *i* ]]; then

  # eza (ls moderne)
  if command -v eza &>/dev/null; then
    alias lls='eza --color=automatic --group-directories-first -h --icons'
    alias lla='eza -la --color=automatic --group-directories-first -h --icons'
    alias tree='eza --tree --level=2 --color=auto --icons'
    alias treee='eza --tree --level=3 --color=auto --icons'
  fi

  # bat (cat moderne)
  if command -v bat &>/dev/null; then
    alias catt='bat --paging=never --style=plain --color=auto'
  fi

  # rg (grep moderne)
  if command -v rg &>/dev/null; then
    alias rgrep='rg'
  fi

  # procs (ps moderne)
  if command -v procs &>/dev/null; then
    alias pps='procs'
  fi
fi
