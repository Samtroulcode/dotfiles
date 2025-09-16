-- lua/plugins/web.lua
return {
	{ "b0o/schemastore.nvim" }, -- pour jsonls (utilisé ci-dessus)
	{ "jose-elias-alvarez/null-ls.nvim", enabled = false }, -- tu utilises conform.nvim
	{ "norcalli/nvim-colorizer.lua", opts = { "*" } },
	{ "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
	{ "David-Kunz/cmp-npm", ft = "json", opts = {} },
	{ "windwp/nvim-ts-autotag", event = "VeryLazy", opts = {} },
	{ "danymat/neogen", dependencies = "nvim-treesitter/nvim-treesitter", opts = { snippet_engine = "luasnip" } },

	-- Tests
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/nvim-nio",
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
