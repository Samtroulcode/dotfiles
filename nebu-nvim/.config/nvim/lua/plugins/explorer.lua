return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = { "Neotree" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = require("config.keymaps").keys.explorer, -- ← maps centralisées
		opts = {
			close_if_last_window = true,
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				filtered_items = { hide_dotfiles = false, hide_gitignored = true },
			},
			window = {
				width = 32,
				mappings = { ["<space>"] = "toggle_node", ["l"] = "open", ["h"] = "close_node", ["o"] = "system_open" },
			},
			default_component_configs = {
				indent = { with_markers = true, padding = 1 },
				git_status = {
					symbols = { unstaged = "", staged = "", untracked = "", renamed = "", deleted = "" },
				},
			},
		},
	},
}
