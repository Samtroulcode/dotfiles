-- L'indentation de base est de 2 (lua, js, toml, json, etc)
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Ma touche leader qui sera SPACE
vim.g.mapleader = " "

-- On charge le gestionnaire de paquet lazy
require("config.lazy")
