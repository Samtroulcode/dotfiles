return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lsp = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local on_attach = function(_, bufnr)
			require("config.keymaps").lsp(bufnr)
		end

		-- Rust: ignoré si rustaceanvim est installé (il gère lui-même RA)
		local has_rustacean = vim.g.rustaceanvim ~= nil
		if not has_rustacean then
			lsp.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = { ["rust-analyzer"] = { cargo = { allFeatures = true }, check = { command = "clippy" } } },
			})
		end

		-- Lua
		lsp.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { Lua = { diagnostics = { globals = { "vim" } } } },
		})

		-- Markdown LSP (basique mais utile)
		lsp.marksman.setup({ capabilities = capabilities, on_attach = on_attach })
	end,
}
