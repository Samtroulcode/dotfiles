return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			transparent_background = false,
			integrations = {
				treesitter = true,
				telescope = { enabled = true },
				render_markdown = true,
				gitsigns = true,
				dashboard = true,
				fzf = true,
				neotree = true,
				notify = true,
				native_lsp = { enabled = true },
				which_key = true,
				noice = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
