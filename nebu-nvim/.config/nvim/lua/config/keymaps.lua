-- lua/config/keymaps.lua
-- Centralise des mappings cohérents et documentés

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Mouvement LSP classiques (sans leader, pour la vitesse)
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: goto definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP: references" })
map("n", "K",  vim.lsp.buf.hover,      { desc = "LSP: hover docs" })

-- Espace LSP sous <leader>l…
map("n", "<leader>lr", vim.lsp.buf.rename,      { desc = "LSP: rename" })
map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "LSP: code action" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Diagnostics: line" })
map("n", "<leader>lD", vim.diagnostic.setloclist, { desc = "Diagnostics: to loclist" })
map("n", "<leader>lf", function()
  -- format via Conform (s'il est installé), sinon fallback LSP
  if pcall(require, "conform") then
    require("conform").format({ lsp_fallback = true })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Format buffer" })

