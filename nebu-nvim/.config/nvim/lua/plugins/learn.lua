return {
	-- Cheatsheet
	{
		"sudormrfbin/cheatsheet.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		cmd = { "Cheatsheet" },
		opts = {
			bundled_cheatsheets = true,
			bundled_plugin_cheatsheets = true,
		},
	},

	-- VimBeGood (training jeu)
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},

	-- Telescope undo (arbre d’undo visuel)
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").setup({ extensions = { undo = {} } })
			pcall(require("telescope").load_extension, "undo")
		end,
	},
}
