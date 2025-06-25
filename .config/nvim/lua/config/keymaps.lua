-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local builtin = require("telescope.builtin")

-- Trouver des fichiers dans ~/.config/nvim (Neovim config)
map("n", "<leader>fc", function()
  builtin.find_files({
    prompt_title = "~ dotfiles ~",
    cwd = vim.fn.expand("~/.config"),
    hidden = true,
    no_ignore = true,
  })
end, { desc = "Telescope: dotfiles" })
