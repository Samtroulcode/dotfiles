return {
	"mrcjkb/rustaceanvim",
	ft = { "rust" },
	init = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(_, bufnr)
					require("config.keymaps").lsp(bufnr) -- tes maps LSP
					-- exemples de raccourcis "outils" Rust (facultatifs)
					vim.keymap.set("n", "<leader>ca", function()
						vim.cmd.RustLsp("codeAction")
					end, { buffer = bufnr, desc = "Rust: code actions" })
					vim.keymap.set("n", "<leader>cr", function()
						vim.cmd.RustLsp("rename")
					end, { buffer = bufnr, desc = "Rust: rename" })
					vim.keymap.set("n", "K", function()
						vim.cmd.RustLsp("hover actions")
					end, { buffer = bufnr, desc = "Rust: hover actions" })
				end,
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
					},
				},
			},
			tools = { hover_actions = { auto_focus = true } },
		}
	end,
}
