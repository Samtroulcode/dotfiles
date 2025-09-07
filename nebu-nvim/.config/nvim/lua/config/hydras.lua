local M = {}

-- Instancie la Hydra "Fenêtres" et l’active
function M.windows()
	local ok, Hydra = pcall(require, "hydra")
	if not ok then
		-- charge le plugin s’il est lazy
		pcall(function()
			require("lazy").load({ plugins = { "hydra.nvim" } })
		end)
		Hydra = require("hydra")
	end

	Hydra({
		name = "Windows",
		mode = "n",
		body = nil, -- on n’attache pas une touche ici, on l’ouvre explicitement
		hint = [[
   _h_ ←  _j_ ↓  _k_ ↑  _l_ →
   _s_ split  _v_ vsplit  _q_ close  _o_ only
   Resize: _H_ _J_ _K_ _L_      Exit: _<Esc>_
]],
		heads = {
			{ "h", "<C-w>h" },
			{ "j", "<C-w>j" },
			{ "k", "<C-w>k" },
			{ "l", "<C-w>l" },
			{ "s", "<C-w>s" },
			{ "v", "<C-w>v" },
			{ "q", "<C-w>c" },
			{ "o", "<C-w>o" },
			{ "H", "<C-w><" },
			{ "J", "<C-w>-" },
			{ "K", "<C-w>+" },
			{ "L", "<C-w>>" },
			{ "<Esc>", nil, { exit = true } },
		},
		config = { hint = { border = "rounded" }, invoke_on_body = true },
	}):activate()
end

return M
