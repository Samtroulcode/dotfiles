return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lsp = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(_, bufnr)
			require("config.keymaps").lsp(bufnr) -- maps LSP buffer-local centralisées
		end

		lsp.rust_analyzer.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				["rust-analyzer"] = { cargo = { allFeatures = true }, check = { command = "clippy" } },
			},
		})

		lsp.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { Lua = { diagnostics = { globals = { "vim" } } } },
		})
	end,
}
