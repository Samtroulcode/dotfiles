return {
  "neovim/nvim-lspconfig",
  config = function()
    local lsp = require("lspconfig")

    -- Exemple rust (si tu utilises rust-analyzer dans $PATH)
    lsp.rust_analyzer.setup({})

    -- Exemple lua (pour éditer ta config sans warnings)
    lsp.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    -- Mappings LSP “standards”
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: goto definition" })
    map("n", "gr", vim.lsp.buf.references, { desc = "LSP: references" })
    map("n", "K",  vim.lsp.buf.hover, { desc = "LSP: hover" })
    map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: rename" })
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: code action" })
  end,
}

