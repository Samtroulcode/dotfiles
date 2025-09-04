return {
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = require("config.keymaps").keys.bufferline, -- ← maps centralisées
		opts = {
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = "slant",
				offsets = {
					{ filetype = "neo-tree", text = "Explorer", text_align = "left", separator = true },
				},
			},
		},
	},
	{
		"echasnovski/mini.bufremove",
		config = true,
	},
}
