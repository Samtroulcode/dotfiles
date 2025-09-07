return {
	"nvim-mini/mini.cursorword",
	version = false,
	config = function()
		require("mini.cursorword").setup({
			delay = 100, -- délai en millisecondes
		})
	end,
	event = "BufReadPost",
}
