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

-- Helpers Dashboard
local function dashboard_open()
	pcall(vim.cmd, "Alpha")
end

local function dashboard_only()
	-- force : ferme tous les buffers/fenêtres, puis ouvre le dashboard
	vim.cmd("silent! %bd!")
	vim.schedule(function()
		pcall(vim.cmd, "Alpha")
		vim.cmd("only")
	end)
end

local function dashboard_toggle()
	local buf_ft = vim.bo.filetype
	if buf_ft == "alpha" then
		-- revenir au dernier buffer visité
		vim.cmd("b#")
	else
		pcall(vim.cmd, "Alpha")
		vim.cmd("only")
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
	for lhs, dir in pairs({
		["<C-h>"] = "h",
		["<C-j>"] = "j",
		["<C-k>"] = "k",
		["<C-l>"] = "l",
	}) do
		-- active en normal ET terminal
		map({ "n", "t" }, lhs, function()
			nav_win(dir)
		end, { desc = "Window " .. dir })
	end

	-- Diagnostics (globaux)
	map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
	map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
	map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostics: line" })
	map("n", "<leader>cD", vim.diagnostic.setloclist, { desc = "Diagnostics: to loclist" })

	-- ===== Lazy (tout sous <leader>l)
	map("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Lazy: home" })
	map("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Lazy: update" })
	map("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Lazy: sync" })
	map("n", "<leader>lc", "<cmd>Lazy check<CR>", { desc = "Lazy: check" })
	map("n", "<leader>lC", "<cmd>Lazy clean<CR>", { desc = "Lazy: clean" })
	map("n", "<leader>lp", "<cmd>Lazy profile<CR>", { desc = "Lazy: profile" })

	-- ===== Dashboard (tout sous <leader>d)
	map("n", "<leader>dd", dashboard_open, { desc = "Dashboard: open" })
	map("n", "<leader>dD", dashboard_only, { desc = "Dashboard: close all & open" })
	map("n", "<leader>dt", dashboard_toggle, { desc = "󰕮 Dashboard: toggle" })
	map("n", "<leader>dR", "<cmd>AlphaRedraw<CR>", { desc = "Dashboard: redraw" })
	map("n", "<leader>dq", "<cmd>qa<CR>", { desc = "Quit all" }) -- (optionnel, pratique)
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

-- TOC Markdown: <leader>ct = générer / <leader>cT = mettre à jour
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(ev)
		vim.keymap.set(
			"n",
			"<leader>ct",
			":GenTocGFM<CR>",
			{ buffer = ev.buf, silent = true, desc = "Markdown: Gen TOC (GFM)" }
		)
		vim.keymap.set(
			"n",
			"<leader>cT",
			":UpdateToc<CR>",
			{ buffer = ev.buf, silent = true, desc = "Markdown: Update TOC" }
		)
	end,
})

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
		{
			"<leader>fp",
			"<cmd>Telescope workspaces<CR>",
			desc = "Find: workspaces",
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

	-- =========================
	-- GIT (tout sous <leader>g)
	-- =========================

	git = {

		-- LazyGit
		lazygit = {
			{ "<leader>gl", "<cmd>LazyGit<CR>", desc = "Git: LazyGit" },
		},

		-- Gitsigns (hunks, blame, diff…)
		gitsigns = {
			-- hunk actions
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk()
				end,
				mode = { "n", "v" },
				desc = "Git: stage hunk",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
				mode = { "n", "v" },
				desc = "Git: reset hunk",
			},
			{
				"<leader>gu",
				function()
					require("gitsigns").undo_stage_hunk()
				end,
				desc = "Git: undo stage",
			},
			{
				"<leader>gS",
				function()
					require("gitsigns").stage_buffer()
				end,
				desc = "Git: stage buffer",
			},
			{
				"<leader>gR",
				function()
					require("gitsigns").reset_buffer()
				end,
				desc = "Git: reset buffer",
			},
			{
				"<leader>gp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Git: preview hunk",
			},

			-- navigation hunk (pratique; tu peux les retirer si tu veux zéro hors <leader>)
			{
				"]h",
				function()
					require("gitsigns").next_hunk()
				end,
				desc = "Git: next hunk",
			},
			{
				"[h",
				function()
					require("gitsigns").prev_hunk()
				end,
				desc = "Git: prev hunk",
			},

			-- blame / diff
			{
				"<leader>gb",
				function()
					require("gitsigns").toggle_current_line_blame()
				end,
				desc = "Git: blame line (toggle)",
			},
			{
				"<leader>gB",
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				desc = "Git: blame line (full)",
			},
			{
				"<leader>g=",
				function()
					require("gitsigns").diffthis()
				end,
				desc = "Git: diffthis",
			},
			{
				"<leader>gD",
				function()
					require("gitsigns").diffthis("~")
				end,
				desc = "Git: diff vs HEAD~",
			},
			{
				"<leader>gt",
				function()
					require("gitsigns").toggle_deleted()
				end,
				desc = "Git: toggle deleted",
			},
		},

		-- Diffview (diffs & historiques propres)
		diffview = {
			{ "<leader>gdo", "<cmd>DiffviewOpen<CR>", desc = "Git: Diffview open" },
			{ "<leader>gdc", "<cmd>DiffviewClose<CR>", desc = "Git: Diffview close" },
			{ "<leader>gdh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: file history (buffer)" },
			{ "<leader>gdH", "<cmd>DiffviewFileHistory<CR>", desc = "Git: repo history" },
		},
	},
	workspaces = {
		{ "<leader>pa", "<cmd>WorkspacesAdd<CR>", desc = "Workspace: add cwd" },
		{ "<leader>po", "<cmd>WorkspacesOpen<CR>", desc = "Workspace: open…" },
		{ "<leader>pr", "<cmd>WorkspacesRemove<CR>", desc = "Workspace: remove" },
		{ "<leader>pn", "<cmd>WorkspacesRename<CR>", desc = "Workspace: rename" },
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
				{ "<leader>g", group = "Git" },
				{ "<leader>b", group = "Buffers" },
				{ "<leader>l", group = "Lazy" },
				{ "<leader>d", group = "Dashboard" },
				{ "<leader>p", group = "Projects / Workspaces" },
				{ "<leader>bh", desc = "Précédent" },
				{ "<leader>bl", desc = "Suivant" },
				{ "<leader>bp", desc = "Picker" },
				{ "<leader>bc", desc = "Fermer" },
				{ "<leader>bC", desc = "Fermer (force)" },
				{ "<leader>bd", desc = "Delete" },
			})
		end
	end,
})

return M
