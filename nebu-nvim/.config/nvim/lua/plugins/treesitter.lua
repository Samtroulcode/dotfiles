return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		highlight = { enable = true },
		indent = { enable = true },
		ensure_installed = {
			-- base
			"bash",
			"lua",
			"vim",
			"vimdoc",
			"regex",
			"markdown",
			"markdown_inline",
			"json",
			"toml",
			"yaml",
			-- web
			"html",
			"css",
			"javascript",
			"typescript",
			"scss",
			"tsx",
			"svelte",
			"vue",
			"jsdoc",
			-- systèmes/compilés
			"c",
			"cpp",
			"rust",
			"go",
			"java",
			-- divers
			"python",
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
