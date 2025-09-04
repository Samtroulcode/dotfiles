return {
	-- Gestionnaire d'outils (LSP/formatters/linters) local à Neovim
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	config = function()
		require("mason").setup()
		-- Rendre visibles les binaires Mason à Neovim (fallback si non présents dans PATH)
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		if not string.find(vim.env.PATH or "", mason_bin, 1, true) then
			vim.env.PATH = mason_bin .. ":" .. (vim.env.PATH or "")
		end
	end,
}
