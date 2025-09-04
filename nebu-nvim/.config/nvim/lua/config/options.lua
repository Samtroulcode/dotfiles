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

vim.opt.showmode = false       -- Evite le -- INSERT --
vim.opt.scrolloff = 4          -- Garde du contexte autour du curseur
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 200       -- Diagnostics/LSP plus réactifs (par défaut ~4000ms)
vim.opt.inccommand = "split"   -- Aperçu live pour :%s/// (substitute)
vim.opt.breakindent = true     -- Indent visuel pour les lignes wrap
vim.opt.linebreak = true       -- Coupe sur les mots, pas en plein milieu
vim.opt.wrap = false           -- (perso) évite les wraps; active linebreak/breakindent si tu le mets à true

-- Recherche --
vim.opt.ignorecase = true -- permet de faire des recherches insensible a la casse...
vim.opt.smartcase = true  -- ... sauf si on met une majuscule
vim.opt.hlsearch = true -- Garde les occurrences surlignées après la recherche
vim.opt.incsearch = true  -- Retour visuel incrémental pendant la saisie

-- Split --
vim.opt.splitbelow = true  -- :split en dessous
vim.opt.splitright = true  -- :vsplit à droite

-- Qol --
vim.opt.timeoutlen = 300  -- Delay avant qu’un mapping échoue (par défaut 1000ms)

vim.opt.swapfile = false  -- Ne pas garder des swaps files
vim.opt.backup = false
vim.opt.undofile = true -- Mais garder l’historique d’undo entre les sessions

vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Auto-completion plus ergonomique

vim.opt.signcolumn = "yes"  -- Une signcolumn (utile pour LSP, Git, diagnostics…)

-- Grep intégré, si ripgrep est présent
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden"
  vim.opt.grepformat = "%f:%l:%c:%m"
end
