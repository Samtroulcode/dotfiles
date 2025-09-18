return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim" },
		-- Améliorations TS/JS
		{ "yioneko/nvim-vtsls" }, -- commandes : VtsExec, VtsRename, etc.
		{ "b0o/schemastore.nvim" }, -- JSON schemas
		{ "windwp/nvim-ts-autotag", opts = {} }, -- auto close/rename tags
		{ "folke/neodev.nvim", opts = { library = { enabled = true, runtime = true, types = true } } },
		{ "luckasRanarison/tailwind-tools.nvim", opts = {} }, -- bonus Tailwind (optionnel mais utile)
		-- (Optionnel) switch colorizer vers le fork maintenu :
		-- { "NvChad/nvim-colorizer.lua", opts = { user_default_options = { names = false } } },
	},
	config = function()
		-- === Diagnostics look & feel ===
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
			virtual_text = {
				spacing = 8,
				source = false,
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
		-- VirtualText sans fond
		local function vt_bg_none()
			for _, n in ipairs({ "Error", "Warn", "Info", "Hint" }) do
				local grp = "DiagnosticVirtualText" .. n
				local cur = vim.api.nvim_get_hl(0, { name = grp, link = false }) or {}
				vim.api.nvim_set_hl(0, grp, vim.tbl_extend("force", cur, { bg = "NONE" }))
			end
		end
		vt_bg_none()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = vt_bg_none })

		-- lsp_lines prêt mais OFF
		pcall(require, "lsp_lines")
		vim.diagnostic.config({ virtual_lines = false })

		local lsp = require("lspconfig")
		local util = require("lspconfig.util")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(client, bufnr)
			-- tes keymaps
			pcall(require, "config.keymaps")
			if package.loaded["config.keymaps"] then
				require("config.keymaps").lsp(bufnr)
			end
		end

		-- Rust: laisse rustaceanvim gérer si présent
		if not vim.g.rustaceanvim then
			lsp.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = { ["rust-analyzer"] = { cargo = { allFeatures = true }, check = { command = "clippy" } } },
			})
		end

		-- lua_ls
		lsp.lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" }, -- Neovim + LÖVE = LuaJIT
					diagnostics = { globals = { "vim", "love" } },
					workspace = {
						checkThirdParty = false, -- évite les prompts lents
						library = vim.api.nvim_get_runtime_file("", true),
						ignoreDir = { "types/nightly" },
					},
					telemetry = { enable = false },
					format = { enable = false }, -- on laisse stylua formater
					hint = { enable = true }, -- inlay hints (optionnel)
				},
			},
		})

		-- Markdown
		lsp.marksman.setup({ capabilities = capabilities, on_attach = on_attach })

		-- JSON (schemastore)
		local ok_schema, schemastore = pcall(require, "schemastore")
		lsp.jsonls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				json = { schemas = ok_schema and schemastore.json.schemas() or nil, validate = { enable = true } },
			},
		})

		-- YAML
		lsp.yamlls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { yaml = { keyOrdering = false } },
		})

		-- HTML / CSS
		lsp.html.setup({ capabilities = capabilities, on_attach = on_attach })
		lsp.cssls.setup({ capabilities = capabilities, on_attach = on_attach })

		-- Svelte
		lsp.svelte.setup({ capabilities = capabilities, on_attach = on_attach })

		-- Tailwind CSS
		lsp.tailwindcss.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			-- (facultatif) root_dir = util.root_pattern("tailwind.config.*", "package.json", ".git"),
		})

		-- Emmet
		lsp.emmet_language_server.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "css", "scss", "sass", "javascriptreact", "typescriptreact", "svelte" },
		})

		-- NOTE: nécessite `svelte-language-server` installé (Mason ✔) pour la location du plugin.
		local function svelte_ts_plugin_location()
			local ok_mason, registry = pcall(require, "mason-registry")
			if ok_mason then
				local ok_pkg, pkg = pcall(registry.get_package, "svelte-language-server")
				if ok_pkg and pkg and pkg.is_installed and pkg:is_installed() and pkg.get_install_path then
					local base = pkg:get_install_path() .. "/node_modules/typescript-svelte-plugin"
					if vim.fn.isdirectory(base) == 1 then
						return base
					end
				end
			end
			-- fallbacks courants (si installé globalement via npm/pnpm/yarn)
			local candidates = {
				vim.fn.expand(
					"~/.local/share/nvim/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin"
				),
				"/usr/local/lib/node_modules/typescript-svelte-plugin",
				"/usr/lib/node_modules/typescript-svelte-plugin",
			}
			for _, p in ipairs(candidates) do
				if vim.fn.isdirectory(p) == 1 then
					return p
				end
			end
			return nil
		end

		local svelte_plugin_path = svelte_ts_plugin_location()

		local vtsls_settings = {
			vtsls = { enableMoveToFileCodeAction = true },
			tsserver = {
				globalPlugins = {
					(function()
						local plugin = {
							name = "typescript-svelte-plugin",
							enableForWorkspaceTypeScriptVersions = true,
						}
						-- n’ajoute "location" que si on a trouvé un chemin fiable
						if svelte_plugin_path then
							plugin.location = svelte_plugin_path
						end
						return plugin
					end)(),
				},
			},
			typescript = {
				preferences = { includeCompletionsForModuleExports = true },
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayVariableTypeHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayVariableTypeHints = true,
				},
			},
		}
		lsp.vtsls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
			settings = vtsls_settings,
		})

		-- ESLint: code actions / fixAll, PAS de diagnostics (on laisse vtsls)
		lsp.eslint.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
				on_attach(client, bufnr)
			end,
			settings = {
				run = "onType",
				validate = "on",
				codeAction = { disableRuleComment = { enable = true, location = "separateLine" } },
				workingDirectory = { mode = "auto" },
			},
			-- coupe la publication de diagnostics côté ESLint (mais garde les actions)
			handlers = {
				["textDocument/publishDiagnostics"] = function() end,
			},
		})
	end,
}
