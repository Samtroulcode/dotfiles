-- return {
--   "folke/which-key.nvim",
--   opts = { delay = 300 },
-- }
-- lua/plugins/which-key.lua
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- délai d’ouverture
		delay = 300,

		-- preset v3: "classic" | "modern" | "helix"
		preset = "modern",

		-- icônes de groupe/séparateurs (v3)
		icons = {
			breadcrumb = "»", -- fil d’Ariane en haut
			separator = "➜", -- entre la touche et la description
			group = "+", -- suffixe des groupes ex: "+git"
			rules = {}, -- tu peux définir des règles par préfixe si besoin
		},

		-- fenêtre (la popup)
		win = {
			border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
			padding = { 1, 2 }, -- {haut/bas, gauche/droite}
			title = " which-key ",
			title_pos = "center", -- "left" | "center" | "right"
			zindex = 1000,
		},

		-- mise en page
		layout = {
			align = "center", -- "left" | "center"
			spacing = 4, -- espaces entre colonnes
			height = { min = 4, max = 25 },
			width = { min = 20, max = 60 }, -- largeur des colonnes
		},

		-- tri lisible: groupes > locaux > alpha (desc insensible à la casse)
		sort = { "group", "local", "alphanum", "icase" },

		-- petites retouches UX
		expand = 0, -- 0: pas d’expansion auto des groupes courts
		show_help = false, -- pas de footer “help”
		keys = { -- remplacements visuels de touches
			-- exemple: ["<space>"] = "SPC",
		},
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
		-- activer/désactiver par mode si tu veux
		-- triggers = { mode = { "n", "v" } },
	},
}
