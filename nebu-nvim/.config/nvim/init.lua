-- Ma touche leader qui sera SPACE
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Chargement de luarocks si un plugin luarocks est utilisé
pcall(require, "luarocks.loader")

-- On charge mes options perso
require("config.options")

-- On charge le gestionnaire de paquet lazy
require("config.lazy")

-- On charge les keymaps
require("config.keymaps")

-- On charge le theme lualine
require("config.lualine-bubble")

-- Chargement des workspaces
require("workspaces").setup({
	path = vim.fn.stdpath("data") .. "/workspaces", -- optionnel
	cd_type = "tab", -- "global" | "tab" | "win"
	sort = "recent", -- "none" | "asc" | "desc" | "recent"
	hooks = {
		open = { "Telescope find_files" }, -- commandes ou fonctions Lua
	},
})
