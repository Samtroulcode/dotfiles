version = "1.0.0"  -- Vérifie avec `xplr --version`

-- Apparence des fichiers
xplr.config.node_types.directory.meta.icon = "  "
xplr.config.node_types.file.meta.icon = " "
xplr.config.node_types.symlink.meta.icon = " "
-- xplr.config.node_types.socket.meta.icon = "󰟧 "

-- ⌨️ Raccourcis perso
local key_bindings = xplr.config.modes.builtin.default.key_bindings

key_bindings.on_key["w"] = {
  help = "open with nvim",
  messages = {
    { BashExec = 'nvim "$XPLR_FOCUS_PATH"' }
  }
}

key_bindings.on_key["e"] = {
  help = "open with default app",
  messages = {
    { BashExec = 'xdg-open "$XPLR_FOCUS_PATH" > /dev/null 2>&1 &' }
  }
}

xplr.config.modes.builtin.default.key_bindings.on_key.q = {
  help = "quit and print pwd",
  messages = {
    "PrintPwdAndQuit",
  },
}

key_bindings.on_key["P"] = {
  help = "preview with kitty icat",
  messages = {
    {
      BashExec = [==[
        if file --mime-type "$XPLR_FOCUS_PATH" | grep -q image/; then
          kitty +kitten icat --clear
          kitty +kitten icat "$XPLR_FOCUS_PATH"
          read -n 1
          kitty +kitten icat --clear
        else
          bat --color=always "$XPLR_FOCUS_PATH" | less -R
        fi
      ]==]
    }
  }
}
