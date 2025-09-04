return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = { lsp_fallback = true, timeout_ms = 500 },
		formatters_by_ft = {
			sh = { "shfmt" },
			lua = { "stylua" },
			javascript = { "prettierd", "prettier" },
			typescript = { "prettierd", "prettier" },
			css = { "prettierd", "prettier" },
			html = { "prettierd", "prettier" },
			markdown = { "prettierd", "prettier" },
			json = { "jq" },
			yaml = { "prettier" },
			toml = { "taplo" },
			python = { "ruff_format" },
			rust = { "rustfmt" },
			go = { "gofumpt", "goimports" },
		},
	},
}
