return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function () 
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "css", "javascript", "html", "python", "json", "toml", "yaml" },
      highlight = { enable = true },
      indent = { enable = true },  
    })
  end
}
