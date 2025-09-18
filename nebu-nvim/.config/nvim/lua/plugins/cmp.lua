return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"windwp/nvim-autopairs", -- pour l’intégration confirm_done
		"David-Kunz/cmp-npm",
		"roobert/tailwindcss-colorizer-cmp.nvim",
	},
	config = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			performance = { max_view_entries = 15 }, -- cap global de la liste (doc officielle)
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fb)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fb()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fb)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fb()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "copilot" }, -- en tête quand activé
				{
					name = "nvim_lsp",
					entry_filter = function(entry, _)
						-- vire le bruit "Text" renvoyé par certains LSP (ex. TS/JS)
						local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
						return kind ~= "Text"
					end,
				},
				{ name = "luasnip" },
			}, {
				{ name = "buffer", keyword_length = 3, group_index = 2 },
				{ name = "npm" },
				{ name = "path" },
			}),
			sorting = {
				priority_weight = 2,
				comparators = {
					require("copilot_cmp.comparators").prioritize,
					require("cmp").config.compare.offset,
					require("cmp").config.compare.exact,
					require("cmp").config.compare.score,
					require("cmp").config.compare.recently_used,
					require("cmp").config.compare.locality,
					require("cmp").config.compare.kind,
					require("cmp").config.compare.sort_text,
					require("cmp").config.compare.length,
					require("cmp").config.compare.order,
				},
			},
		})
		-- activer la colorisation Tailwind
		require("tailwindcss-colorizer-cmp").setup({})

		-- autopairs <-> cmp
		local ok, cmp_ap = pcall(require, "nvim-autopairs.completion.cmp")
		if ok then
			cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
		end
		pcall(function()
			require("cmp-npm").setup({})
		end)
	end,
}
