# Core interactive options, history, editor defaults.

setopt complete_aliases
setopt interactivecomments extendedglob

# UX: free Ctrl+S/Ctrl+Q (flow control off)
[[ -t 0 ]] && stty -ixon

# Reduce ESC latency (vi/esc bindings)
KEYTIMEOUT=1

# Strong, clean history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt inc_append_history hist_verify hist_ignore_all_dups hist_reduce_blanks
setopt hist_ignore_space hist_expire_dups_first

# Default editor
export EDITOR=nvim
export VISUAL=nvim

# Use nvim as man pager
export MANPAGER='nvim +Man!'
