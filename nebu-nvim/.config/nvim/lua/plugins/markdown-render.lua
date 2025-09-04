return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		opts = {
			-- Rendu en normal/command/terminal ; brut en insert
			render_modes = { "n", "c", "t" },
			-- On coupe complètement LaTeX
			latex = { enabled = false },
		},
	},
}
