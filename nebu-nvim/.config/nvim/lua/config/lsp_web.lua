local M = {}

function M.setup(capabilities, base_on_attach)
	local lsp = require("lspconfig")
	local util = require("lspconfig.util")

	-- on_attach commun
	local function on_attach(client, bufnr)
		if base_on_attach then
			base_on_attach(client, bufnr)
		end
		-- (pas de disable ici → on laisse les 2 serveurs parler si attachés,
		--  l’agrégateur n’affichera qu’UNE bulle par ligne)
	end

	-- vtsls (TS/JS)
	lsp.vtsls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
		settings = {
			vtsls = { enableMoveToFileCodeAction = true },
			typescript = {
				preferences = { includeCompletionsForModuleExports = true },
				inlayHints = { includeInlayParameterNameHints = "all", includeInlayVariableTypeHints = true },
			},
			javascript = {
				inlayHints = { includeInlayParameterNameHints = "all", includeInlayVariableTypeHints = true },
				-- NB: avec //@ts-check ou jsconfig.json, vtsls fera aussi des diags JS
				-- (installation officielle: `npm i -g @vtsls/language-server && vtsls --stdio`) :contentReference[oaicite:4]{index=4}
			},
		},
	})

	-- ESLint (JS/HTML/Svelte…) — nécessite eslint installé/configuré dans le projet,
	-- comme l’extension VS Code. :contentReference[oaicite:5]{index=5}
	lsp.eslint.setup({
		capabilities = capabilities,
		filetypes = { "javascript", "javascriptreact", "svelte", "html", "typescript", "typescriptreact" },
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			on_attach(client, bufnr)
		end,
		settings = {
			run = "onType",
			validate = "on",
			codeAction = { disableRuleComment = { enable = true, location = "separateLine" } },
		},
	})

	-- Svelte / HTML / CSS / Tailwind / JSON / Emmet
	lsp.svelte.setup({ capabilities = capabilities, on_attach = on_attach })
	lsp.html.setup({ capabilities = capabilities, on_attach = on_attach })
	lsp.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
	lsp.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })

	local ok_schema, schemastore = pcall(require, "schemastore")
	lsp.jsonls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			json = { schemas = ok_schema and schemastore.json.schemas() or nil, validate = { enable = true } },
		},
	})

	lsp.emmet_language_server.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "html", "css", "scss", "sass", "javascriptreact", "typescriptreact", "svelte" },
	})
end

return M
