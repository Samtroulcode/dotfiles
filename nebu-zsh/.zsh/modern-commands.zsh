# ~/.zsh/modern-commands.zsh
# Alias vers les commandes modernes, sans écraser les commandes classiques

# Chargement uniquement en shell interactif
if [[ $- == *i* ]]; then

  # eza (ls moderne)
  if command -v eza &>/dev/null; then
    alias ls='eza --color=always --group-directories-first -h --icons always'
    alias la='eza -a --color=always --group-directories-first -h --icons always'
    alias ll='eza -l --color=always --group-directories-first -h --icons always'
    alias lla='eza -la --color=always --group-directories-first -h --icons always'
    alias tree='eza --tree --color=auto --icons always'
    alias tree2='eza --tree --level=2 --color=auto --icons always'
    alias tree3='eza --tree --level=3 --color=auto --icons always'
  fi

  # bat (cat moderne)
  if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain --color=auto'
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
