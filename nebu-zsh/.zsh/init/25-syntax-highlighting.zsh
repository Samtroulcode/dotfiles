# Theme + zsh-syntax-highlighting.
# Theme must be loaded BEFORE zsh-syntax-highlighting.

[[ -n ${ZSH_EXECUTION_STRING-} ]] && return 0

[[ -r "$HOME/.zsh/themes/catpuccin.zsh" ]] && source "$HOME/.zsh/themes/catpuccin.zsh"
# [[ -r "$HOME/.zsh/themes/drac.zsh" ]] && source "$HOME/.zsh/themes/drac.zsh"

[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
