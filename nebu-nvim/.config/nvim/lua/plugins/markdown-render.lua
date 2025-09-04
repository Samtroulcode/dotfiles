return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" }, -- charge uniquement sur .md
		opts = {
			-- En normal/command/terminal = rendu ; en insert = brut
			render_modes = { "n", "c", "t" },
			-- tout le reste est optionnel ; défauts déjà bien choisis
		},
	},
}
