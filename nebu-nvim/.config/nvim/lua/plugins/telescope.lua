return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = require("config.keymaps").keys.telescope,
		config = function()
			local telescope = require("telescope")
			telescope.setup({})
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "workspaces")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	-- Remplacement de ahmedkhalf/project.nvim
	{
		"natecraddock/workspaces.nvim",
		event = "VeryLazy",
		keys = require("config.keymaps").keys.workspaces, -- ← consomme tes maps
		config = function()
			require("workspaces").setup({
				cd_type = "tab",
				sort = "recent",
				hooks = { open = { "Telescope find_files" } },
			})
		end,
	},
}
