-- lua/config/keymaps.lua
-- Fichier unique pour mes keymaps.
-- - M.apply_general(): maps générales (pas liées à un plugin)
-- - M.lsp(bufnr):      maps LSP buffer-local
-- - M.keys.*:          tables lues par lazy.nvim (lazy-load par touche)

local M = {}
local map = vim.keymap.set

-- ---- helper: navigation fenêtre qui gère terminal + tmux (vim-tmux-navigator) ----
local function nav_win(dir)
	if vim.bo.buftype == "terminal" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
	end
	local before = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. dir)
	local after = vim.api.nvim_get_current_win()
	if before == after then
		local bydir = { h = "TmuxNavigateLeft", j = "TmuxNavigateDown", k = "TmuxNavigateUp", l = "TmuxNavigateRight" }
		local tm = bydir[dir]
		if tm and vim.fn.exists(":" .. tm) == 2 then
			vim.cmd(tm)
		end
	end
end

-- =========================
-- GÉNÉRALES (pas de plugin)
-- =========================
function M.apply_general()
	-- Sauvegarde / quit
	map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write" })
	map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
	map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })

	-- Effacer le highlight de recherche
	map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "No HL search" })

	-- Fenêtres (normal + terminal)
	for lhs, dir in pairs({ ["<C-h>"] = "h", ["<C-j>"] = "j", ["<C-k>"] = "k", ["<C-l>"] = "l" }) do
		map({ "n", "t" }, lhs, function()
			nav_win(dir)
		end, { desc = "Window " .. dir })
	end

	-- Diagnostics (globaux)
	map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
	map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
	map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostics: line" })
	map("n", "<leader>cD", vim.diagnostic.setloclist, { desc = "Diagnostics: to loclist" })
end

-- =========================
-- LSP (buffer-local)
-- =========================
function M.lsp(bufnr)
	local b = { buffer = bufnr, silent = true }
	map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("keep", { desc = "LSP: definition" }, b))
	map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("keep", { desc = "LSP: references" }, b))
	map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("keep", { desc = "LSP: hover" }, b))
	map("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("keep", { desc = "LSP: rename" }, b))
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("keep", { desc = "LSP: code action" }, b))
	map("n", "<leader>cf", function()
		if pcall(require, "conform") then
			require("conform").format({ lsp_fallback = true })
		else
			vim.lsp.buf.format({ async = true })
		end
	end, vim.tbl_extend("keep", { desc = "Format buffer" }, b))
end

-- =========================
-- Clés destinées aux specs lazy
-- (pour laisser lazy.nvim faire le lazy-load par touche)
-- =========================
M.keys = {
	telescope = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Telescope: files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Telescope: live grep",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Telescope: buffers",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Telescope: help",
		},
	},

	-- Bufferline : TOUT sous <leader>b …
	bufferline = {
		-- suivant / précédent
		{ "<leader>bl", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer suivant" },
		{ "<leader>bh", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer précédent" },

		-- accès direct 1..9
		{ "<leader>b1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Aller buffer 1" },
		{ "<leader>b2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Aller buffer 2" },
		{ "<leader>b3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Aller buffer 3" },
		{ "<leader>b4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Aller buffer 4" },
		{ "<leader>b5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Aller buffer 5" },
		{ "<leader>b6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Aller buffer 6" },
		{ "<leader>b7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Aller buffer 7" },
		{ "<leader>b8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Aller buffer 8" },
		{ "<leader>b9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Aller buffer 9" },

		-- utilitaires
		{ "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Picker de buffer" },
		{
			"<leader>bc",
			function()
				require("mini.bufremove").delete(0, false)
			end,
			desc = "Fermer buffer",
		},
		{
			"<leader>bC",
			function()
				require("mini.bufremove").delete(0, true)
			end,
			desc = "Fermer (force)",
		},
		{
			"<leader>bd",
			function()
				require("mini.bufremove").delete(0, false)
			end,
			desc = "Buffer delete",
		},

		-- (optionnels mais pratiques, pas sous <leader>)
		{ "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer suivant" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer précédent" },
	},

	explorer = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer: toggle" },
		{ "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Explorer: reveal file" },
	},
}

-- Enregistrement auto des maps générales + hints which-key
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		M.apply_general()
		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>c", group = "Code / LSP" },
				{ "<leader>f", group = "Find (Telescope)" },
				{ "<leader>b", group = "Buffers" },
				{ "<leader>bh", desc = "Précédent" },
				{ "<leader>bl", desc = "Suivant" },
				{ "<leader>bp", desc = "Picker" },
				{ "<leader>bc", desc = "Fermer" },
				{ "<leader>bC", desc = "Fermer (force)" },
				{ "<leader>bd", desc = "Delete" },
				{ "<leader>b1", desc = "Buffer 1" },
				{ "<leader>b2", desc = "Buffer 2" },
				{ "<leader>b3", desc = "Buffer 3" },
				{ "<leader>b4", desc = "Buffer 4" },
				{ "<leader>b5", desc = "Buffer 5" },
				{ "<leader>b6", desc = "Buffer 6" },
				{ "<leader>b7", desc = "Buffer 7" },
				{ "<leader>b8", desc = "Buffer 8" },
				{ "<leader>b9", desc = "Buffer 9" },
			})
		end
	end,
})

return M
