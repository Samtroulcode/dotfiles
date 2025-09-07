-- return {
-- 	-- 1) Cheatsheet (recherche via Telescope)
-- 	{
-- 		"sudormrfbin/cheatsheet.nvim",
-- 		dependencies = { "nvim-telescope/telescope.nvim" },
-- 		cmd = { "Cheatsheet" },
-- 		keys = {
-- 			{ "<leader>?", "<cmd>Cheatsheet<CR>", desc = "Cheatsheet: open" },
-- 		},
-- 		opts = {
-- 			bundled_cheatsheets = true, -- inclut vim, tmux, etc.
-- 			bundled_plugin_cheatsheets = true, -- cheatsheets de plugins
-- 		},
-- 	},
--
-- 	-- 2) Jeu pour s'entraîner aux motions
-- 	{
-- 		"ThePrimeagen/vim-be-good",
-- 		cmd = "VimBeGood",
-- 		keys = {
-- 			{ "<leader>vb", "<cmd>VimBeGood<CR>", desc = "VimBeGood (train)" },
-- 		},
-- 	},
--
-- 	-- 3) Coach d’habitudes: punit les flèches/repets, encourage motions
-- 	{
-- 		"m4xshen/hardtime.nvim",
-- 		event = "VeryLazy",
-- 		keys = {
-- 			{ "<leader>uh", "<cmd>HardtimeToggle<CR>", desc = "Hardtime: toggle" },
-- 		},
-- 		opts = {
-- 			max_time = 2000, -- délai toléré entre répétitions (ms)
-- 			restriction_mode = "hint", -- montre un hint plutôt que bloquer sec
-- 			disabled_keys = { ["<Up>"] = {}, ["<Down>"] = {}, ["<Left>"] = {}, ["<Right>"] = {} },
-- 		},
-- 	},
--
-- 	-- 4) Hydra “fenêtres” (overlay d’aide + gestes à mémoriser)
-- 	{
-- 		"anuvyklack/hydra.nvim",
-- 		keys = { "<leader>W" }, -- chargera sur la touche
-- 		config = function()
-- 			local Hydra = require("hydra")
-- 			Hydra({
-- 				name = "Windows",
-- 				mode = "n",
-- 				body = "<leader>W",
-- 				hint = [[
--    _h_ ←  _j_ ↓  _k_ ↑  _l_ →
--    _s_ split  _v_ vsplit  _q_ close  _o_ only
--    Resize: _H_ _J_ _K_ _L_      Exit: _<Esc>_
-- ]],
-- 				heads = {
-- 					{ "h", "<C-w>h" },
-- 					{ "j", "<C-w>j" },
-- 					{ "k", "<C-w>k" },
-- 					{ "l", "<C-w>l" },
-- 					{ "s", "<C-w>s" },
-- 					{ "v", "<C-w>v" },
-- 					{ "q", "<C-w>c" },
-- 					{ "o", "<C-w>o" },
-- 					{ "H", "<C-w><" },
-- 					{ "J", "<C-w>-" },
-- 					{ "K", "<C-w>+" },
-- 					{ "L", "<C-w>>" },
-- 					{ "<Esc>", nil, { exit = true } },
-- 				},
-- 				config = { hint = { border = "rounded" }, invoke_on_body = true },
-- 			})
-- 		end,
-- 	},
--
-- 	-- 5) Voir & utiliser les marks (tu les apprendras en les voyant)
-- 	{
-- 		"chentoast/marks.nvim",
-- 		event = { "BufReadPost", "BufNewFile" },
-- 		opts = { default_mappings = true, cyclic = true, mappings = {} },
-- 	},
--
-- 	-- 6) Playground TS: comprendre la structure du buffer (excellent pour motions/objets)
-- 	{
-- 		"nvim-treesitter/playground",
-- 		dependencies = { "nvim-treesitter/nvim-treesitter" },
-- 		cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
-- 		keys = {
-- 			{ "<leader>tp", "<cmd>TSPlaygroundToggle<CR>", desc = "TS: playground" },
-- 		},
-- 	},
--
-- 	-- 7) Undo visuel (apprendre à dompter u / <C-r>)
-- 	{
-- 		"debugloop/telescope-undo.nvim",
-- 		dependencies = { "nvim-telescope/telescope.nvim" },
-- 		keys = {
-- 			{ "<leader>fu", "<cmd>Telescope undo<CR>", desc = "Telescope: undo tree" },
-- 		},
-- 		config = function()
-- 			require("telescope").setup({ extensions = { undo = {} } })
-- 			pcall(require("telescope").load_extension, "undo")
-- 		end,
-- 	},
-- }
return {
	-- Cheatsheet
	{
		"sudormrfbin/cheatsheet.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		cmd = { "Cheatsheet" },
		opts = {
			bundled_cheatsheets = true,
			bundled_plugin_cheatsheets = true,
		},
	},

	-- VimBeGood (training jeu)
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},

	-- Hardtime (coach de bonnes habitudes)
	{
		"m4xshen/hardtime.nvim",
		event = "VeryLazy",
		opts = {
			max_time = 2000,
			restriction_mode = "hint",
			disabled_keys = {
				["<Up>"] = {},
				["<Down>"] = {},
				["<Left>"] = {},
				["<Right>"] = {},
			},
		},
	},

	-- Hydra (on ne met PAS de touche ici, on instancie via un helper)
	{
		"anuvyklack/hydra.nvim",
		lazy = true, -- sera chargé par require() quand on déclenche
	},

	-- Marks (visualiser/maîtriser les marks)
	{
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = { default_mappings = true, cyclic = true, mappings = {} },
	},

	-- Treesitter Playground (comprendre l’AST)
	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
	},

	-- Telescope undo (arbre d’undo visuel)
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").setup({ extensions = { undo = {} } })
			pcall(require("telescope").load_extension, "undo")
		end,
	},
}
