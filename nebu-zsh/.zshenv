# ~/.zshenv
#
# This file is sourced by *all* zsh invocations (interactive, non-interactive,
# login shells, scripts). Keep it minimal and silent.

if [[ -r "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

if [[ -r "$HOME/.zsh/env.zsh" ]]; then
  . "$HOME/.zsh/env.zsh"
fi
