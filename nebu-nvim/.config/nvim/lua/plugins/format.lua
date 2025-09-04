-- Conform = routeur de formatters : préfère l’outil système si présent,
-- sinon utilise ceux fournis par Mason (si installés)
return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = { lsp_fallback = true, timeout_ms = 500 },
    formatters_by_ft = {
      -- Shell / POSIX
      sh = { "shfmt" },

      -- Lua
      lua = { "stylua" },

      -- Web
      javascript = { "prettierd", "prettier", "biome" }, -- ordre = préférence
      typescript = { "prettierd", "prettier", "biome" },
      css = { "prettierd", "prettier" },
      html = { "prettierd", "prettier" },

      -- Markdown / JSON / YAML / TOML
      markdown = { "prettierd", "prettier" },
      json = { "jq" },
      yaml = { "prettier" }, -- "prettierd" supporte aussi yaml
      toml = { "taplo" },

      -- Python
      python = { "ruff_format" },

      -- Rust / Go
      rust = { "rustfmt" },  -- via rustup
      go = { "gofumpt", "goimports" }, -- ou "gofmt"
    },
  },
}
