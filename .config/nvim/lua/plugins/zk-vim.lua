return {
  "zk-org/zk-nvim",
  config = function()
    require("zk").setup({
      picker = "telescope", -- ou "telescope" si tu l'utilises
      lsp = {
        config = { cmd = { "zk", "lsp" }, name = "zk", filetypes = { "markdown" } },
        auto_attach = { enabled = true },
      },
    })
  end,
}
