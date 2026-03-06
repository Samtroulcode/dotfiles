# Oh-My-Zsh and core plugins.

# When running `zsh -ic '...'`, keep startup minimal.
[[ -n ${ZSH_EXECUTION_STRING-} ]] && return 0

export ZSH="$HOME/.oh-my-zsh"
plugins=(git sudo common-aliases colored-man-pages fzf)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Autosuggestions
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Ctrl+F widget for wikiman
[[ -r /usr/share/wikiman/widgets/widget.zsh ]] \
  && source /usr/share/wikiman/widgets/widget.zsh
