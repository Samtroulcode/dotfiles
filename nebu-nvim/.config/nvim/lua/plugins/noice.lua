return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			documentation = {
				view = "hover",
				opts = { border = { style = "rounded" } },
			},
		},
		-- Ligne de commande en fenêtre façon “Telescope”
		cmdline = { view = "cmdline_popup" },
		views = {
			cmdline_popup = {
				position = { row = "40%", col = "50%" },
				size = { width = 80, height = "auto" },
				border = { style = "rounded" },
				win_options = {
					winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
				},
			},
		},
		presets = {
			bottom_search = false,
			command_palette = false,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = true,
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
}
