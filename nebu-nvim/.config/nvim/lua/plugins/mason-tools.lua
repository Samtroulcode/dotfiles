return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			-- Formatters
			"shfmt",
			"stylua",
			"prettierd",
			"prettier",
			"taplo",
			"jq",
			"black",
			"isort",
			"ruff", -- (ruff_format via ruff >=0.0.290)
			"gofumpt",
			"goimports",
			-- (Rustfmt n’est pas géré par Mason : utilise rustup)
		},
		auto_update = false,
		run_on_start = true,
	},
}
