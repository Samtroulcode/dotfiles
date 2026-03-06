# ~/.zsh/env.zsh
#
# Minimal environment shared by all zsh shells.
# Avoid any interactive-only behavior here.

export LANG=fr_FR.UTF-8

# Clean, de-duplicated PATH using zsh's $path array.
typeset -U path PATH
path=(
  "$HOME/scripts"
  "$HOME/.local/bin"
  "$HOME/bin"
  "/usr/local/bin"
  "$HOME/bin/mpv-tools/TOOLS"
  "$HOME/.opencode/bin"
  $path
)

export PATH
