return {
	-- 1) TypeScript/JavaScript ergonomique
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
				tsserver_format_options = {}, -- on laisse Conform formatter
			},
		},
	},

	-- 2) Autres LSP utiles au web
	{ "b0o/schemastore.nvim" }, -- pour jsonls
	{ "jose-elias-alvarez/null-ls.nvim", enabled = false }, -- tu utilises conform.nvim
	{ "norcalli/nvim-colorizer.lua", opts = { "*" } },
	{ "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
	{ "David-Kunz/cmp-npm", ft = "json", opts = {} },
	{ "windwp/nvim-ts-autotag", event = "VeryLazy", opts = {} },
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		opts = { snippet_engine = "luasnip" },
	},

	-- 3) Tests
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/nvim-nio", -- <<< requis
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({
						jestCommand = "pnpm test",
						env = { CI = true },
					}),
				},
			})
		end,
	},
}
