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

		-- Svelte
		lsp.svelte.setup({ capabilities = capabilities, on_attach = on_attach })

		-- Tailwind CSS LSP
		lsp.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })

		-- HTML / CSS
		lsp.html.setup({ capabilities = capabilities, on_attach = on_attach })
		lsp.cssls.setup({ capabilities = capabilities, on_attach = on_attach })

		-- JSON avec schemastore
		local ok_schema, schemastore = pcall(require, "schemastore")
		lsp.jsonls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				json = {
					schemas = ok_schema and schemastore.json.schemas() or nil,
					validate = { enable = true },
				},
			},
		})

		-- YAML (clé: désactiver l’ordonnancement strict)
		lsp.yamlls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { yaml = { keyOrdering = false } },
		})

		-- Emmet (HTML/CSS/JSX/TSX/Svelte)
		lsp.emmet_language_server.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "css", "scss", "sass", "javascriptreact", "typescriptreact", "svelte" },
		})

		-- ESLint (diagnostics/actions; formatting désactivé pour laisser Conform)
		lsp.eslint.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
				on_attach(client, bufnr)
			end,
		})
	end,
}
