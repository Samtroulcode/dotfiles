return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Icônes & signs par sévérité (sobre / Catppuccin-friendly)
		local diag_icons = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌶",
		}
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			},
		})
		-- Diagnostics: inline stylé + espacé
		vim.diagnostic.config({
			virtual_text = {
				spacing = 8, -- plus éloigné de ton code
				source = false, -- on l’intègre au message si besoin
				prefix = function(d)
					return (diag_icons[d.severity] or "●") .. " "
				end,
				format = function(d)
					local msg = d.message:gsub("\n", " "):gsub("%s+", " ")
					if d.code and type(d.code) == "string" and #d.code < 12 then
						return string.format("%s  ·  %s", msg, d.code)
					end
					return msg
				end,
			},
			underline = true,
			severity_sort = true,
			update_in_insert = false,
			float = { border = "rounded", source = "always", focusable = false },
		})

		-- VirtualText sans fond (reste clean avec Catppuccin)
		local function vt_bg_none()
			for _, n in ipairs({ "Error", "Warn", "Info", "Hint" }) do
				local grp = "DiagnosticVirtualText" .. n
				local cur = vim.api.nvim_get_hl(0, { name = grp, link = false }) or {}
				vim.api.nvim_set_hl(0, grp, vim.tbl_extend("force", cur, { bg = "NONE" }))
			end
		end
		vt_bg_none()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = vt_bg_none })

		-- lsp_lines prêt mais OFF par défaut (toggle depuis les mappings)
		pcall(require, "lsp_lines")
		vim.diagnostic.config({ virtual_lines = false })

		local lsp = require("lspconfig")
		local util = require("lspconfig.util")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(client, bufnr)
			require("config.keymaps").lsp(bufnr)
			-- UN SEUL PRODUCTEUR JS/TS : vtsls
			-- -> désactive explicitement les diagnostics d’ESLint en js/ts/svelte (on laisse html).
			if client.name == "eslint" then
				local ft = vim.bo[bufnr].filetype
				if
					ft == "javascript"
					or ft == "javascriptreact"
					or ft == "typescript"
					or ft == "typescriptreact"
					or ft == "svelte"
				then
					local ns = vim.lsp.diagnostic.get_namespace(client.id)
					-- 1) désactive pour ce buffer/namespace (empêche les publications futures)
					vim.diagnostic.disable(bufnr, ns)
					-- 2) nettoie ce qui a déjà été publié
					vim.schedule(function()
						vim.diagnostic.reset(ns, bufnr)
					end)
				end
			end
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

		-- TypeScript / JavaScript → vtsls = producteur unique des diagnostics
		lsp.vtsls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
			-- Quelques options vtsls/ts utiles (facultatif, garde ton style par défaut)
			settings = {
				vtsls = { enableMoveToFileCodeAction = true },
				typescript = {
					preferences = { includeCompletionsForModuleExports = true },
					inlayHints = { includeInlayParameterNameHints = "all", includeInlayVariableTypeHints = true },
				},
				javascript = {
					inlayHints = { includeInlayParameterNameHints = "all", includeInlayVariableTypeHints = true },
				},
			},
		})

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
