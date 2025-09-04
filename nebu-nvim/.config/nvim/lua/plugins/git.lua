return {
	-- 1) LazyGit wrapper
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = require("config.keymaps").keys.git.lazygit,
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- 2) Gitsigns: signes + hunks + blame + diff
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = require("config.keymaps").keys.git.gitsigns,
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			current_line_blame = false,
			preview_config = { border = "rounded" },
		},
	},

	-- 3) Diffview: vues diff & historiques
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		keys = require("config.keymaps").keys.git.diffview,
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		opts = {
			enhanced_diff_hl = true,
			view = { merge_tool = { layout = "diff3_mixed" } },
		},
	},
}
