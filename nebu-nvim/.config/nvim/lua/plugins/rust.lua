return {
	"mrcjkb/rustaceanvim",
	ft = { "rust" },
	init = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(_, bufnr)
					require("config.keymaps").lsp(bufnr) -- tes maps LSP
				end,
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
					},
				},
			},
		}
	end,
}
