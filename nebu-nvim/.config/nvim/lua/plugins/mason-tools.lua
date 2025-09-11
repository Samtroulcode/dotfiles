return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			-- Formatters/Linters
			"prettierd",
			"eslint_d",
			"jq",
			"shfmt",
			"stylua",
			"taplo",
			"black",
			"isort",
			"ruff",
			"gofumpt",
			"goimports",

			-- LSP Web
			"typescript-language-server",
			"eslint-lsp",
			"html-lsp",
			"css-lsp",
			"json-lsp",
			"yaml-language-server",
			"emmet-language-server",
			"tailwindcss-language-server",
			"svelte-language-server",

			-- (facultatif) debug JS
			"js-debug-adapter",
		},
		auto_update = false,
		run_on_start = true,
	},
}
