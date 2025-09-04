-- 1) Bordures arrondies + taille des popups LSP
local with = vim.lsp.with
vim.lsp.handlers["textDocument/hover"] = with(vim.lsp.handlers.hover, { border = "rounded", max_width = 84 })
vim.lsp.handlers["textDocument/signatureHelp"] =
	with(vim.lsp.handlers.signature_help, { border = "rounded", max_width = 84 })

-- 2) Diagnostics flottants : même style
vim.diagnostic.config({
	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})

-- 3) Unifier les couleurs des flottants avec Telescope
--    (affecte TOUS les floats : hover, signature, diagnostics, etc.)
vim.api.nvim_set_hl(0, "NormalFloat", { link = "TelescopeNormal" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeBorder" })

-- 4) (optionnel) Légère transparence des menus/flottants
vim.opt.winblend = 8 -- floats
vim.opt.pumblend = 8 -- completion menu
