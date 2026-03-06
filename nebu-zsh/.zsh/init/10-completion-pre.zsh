# Completion paths and cache settings (must be set before compinit).

fpath=("$HOME/.zsh/completions" $fpath)

: "${XDG_CACHE_HOME:=$HOME/.cache}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
