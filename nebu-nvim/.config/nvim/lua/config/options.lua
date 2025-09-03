-- Indentation de base de 2 (lua, js, toml, json, etc)
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Clipboard
vim.opt.clipboard = "unnamedplus"  -- Permet d'utiliser + register, donc copier dans nvim avec y, d, x, etc, ira dans le clipboard systeme

-- UI --
vim.opt.number = true  -- Affiche le numéro de ligne absolu sur le curseur
vim.opt.relativenumber = true  -- Affiche le numéro de ligne relatif au curseur pour déplacement plus rapide
vim.opt.mouse = "a"  -- Active la souris partour
vim.opt.termguicolors = true  -- Couleurs
vim.opt.cursorline = true -- highlight la ligne actuelle

-- Search --
vim.opt.ignorecase = true -- permet de faire des recherches insensible a la casse...
vim.opt.smartcase = true  -- ... sauf si on met une majuscule

-- Split behavior --
vim.opt.splitbelow = true  -- :split en dessous
vim.opt.splitright = true  -- :vsplit à droite

-- Qol --
vim.opt.timeoutlen = 300  -- Delay avant qu’un mapping échoue (par défaut 1000ms)

vim.opt.swapfile = false  -- Ne pas garder des swaps files
vim.opt.backup = false
vim.opt.undofile = true -- Mais garder l’historique d’undo entre les sessions

vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Auto-completion plus ergonomique

vim.opt.signcolumn = "yes"  -- Une signcolumn (utile pour LSP, Git, diagnostics…)
