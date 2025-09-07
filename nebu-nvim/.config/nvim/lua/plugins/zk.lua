return {
	"zk-org/zk-nvim",
	main = "zk",
	ft = "markdown",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"folke/which-key.nvim",
	},
	opts = {
		picker = "telescope",
		lsp = {
			config = {
				cmd = { "zk", "lsp" },
				name = "zk",
			},
			auto_attach = {
				enabled = true,
				filetypes = { "markdown" },
			},
		},
	},
}
