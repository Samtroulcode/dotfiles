alias v="nvim"
alias v-lazy="NVIM_APPNAME=LazyVim nvim"
alias v-kick="NVIM_APPNAME=kickstart nvim"
alias v-chad="NVIM_APPNAME=NvChad nvim"
alias v-astro="NVIM_APPNAME=AstroNvim nvim"
alias v-nebu="NVIM_APPNAME=nebuvim nvim"

function vs() {
  items=("default" "nvim-kickstart" "LazyVim" "NvChad" "AstroNvim" "nebuvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}
