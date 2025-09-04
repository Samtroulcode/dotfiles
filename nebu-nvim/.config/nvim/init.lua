-- Ma touche leader qui sera SPACE
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- On charge mes options perso
require("config.options")

-- On charge le gestionnaire de paquet lazy
require("config.lazy")

-- On charge les keymaps
require("config.keymaps")
