return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = require("config.keymaps").keys.telescope, -- ← maps centralisées
		config = function()
			require("telescope").setup({})
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		config = function()
			require("project_nvim").setup({
				manual_mode = false,
				detection_methods = { "pattern", "lsp" },
				patterns = {
					".git",
					"_darcs",
					".hg",
					".bzr",
					"Cargo.toml",
					"package.json",
					"pyproject.toml",
					"Makefile",
					"CMakeLists.txt",
				},
				show_hidden = true,
				silent_chdir = true,
				scope_chdir = "tab",
			})
			require("telescope").load_extension("projects")
		end,
	},
}
