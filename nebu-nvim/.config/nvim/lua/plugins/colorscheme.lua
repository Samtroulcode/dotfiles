return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      integrations = {
        treesitter = true,
        telescope = true,
        gitsigns = true,
        native_lsp = { enabled = true },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}

