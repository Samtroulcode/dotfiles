# Prompt/tools initializers.

if [[ -z ${ZSH_EXECUTION_STRING-} ]]; then
  command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
  command -v mcfly >/dev/null 2>&1 && eval "$(mcfly init zsh)"
fi
