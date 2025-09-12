return {
	"rcarriga/nvim-notify",
	lazy = false, -- charge tôt, avant Noice
	priority = 900, -- (optionnel) s'assure de passer avant
	opts = function()
		-- pas de transparence fantôme → on évite les "bandes noires"
		-- et on ne touche PAS aux groupes Notify* (laisse Catppuccin les colorer)
		return {
			stages = "fade_in_slide_out", -- évite les artefacts alpha de "fade"
			timeout = 3000,
			render = "default",
			background_colour = "#181825", -- Catppuccin Mocha "mantle"
			on_open = function(win)
				-- uniformise avec tes floats (Telescope* déjà linkés dans ui.lua)
				vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:NormalFloat,FloatBorder:FloatBorder")
			end,
		}
	end,
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)
		-- NE PAS ré-affecter vim.notify ici : Noice le gère lui-même quand présent
		-- (sinon Noice peut re-pointer vim.notify sur sa propre implémentation)
	end,
}
