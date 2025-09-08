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

	-- Hardtime (coach de bonnes habitudes)
	{
		"m4xshen/hardtime.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			max_time = 2000,
			restriction_mode = "hint",
		},
	},

	-- Hydra (on ne met PAS de touche ici, on instancie via un helper)
	{
		"anuvyklack/hydra.nvim",
		lazy = true, -- sera chargé par require() quand on déclenche
	},

	-- Marks (visualiser/maîtriser les marks)
	{
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = { default_mappings = true, cyclic = true, mappings = {} },
	},

	-- Treesitter Playground (comprendre l’AST)
	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
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
