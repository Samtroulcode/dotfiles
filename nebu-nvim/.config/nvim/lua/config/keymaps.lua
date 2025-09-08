-- lua/config/keymaps.lua
local M = {}
local map = vim.keymap.set

-- ---- helper: navigation fenêtre qui gère terminal + tmux ----
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

-- ---- helpers buffers ----
local function buf_delete(buf, force)
	buf = buf or 0
	if pcall(require, "mini.bufremove") then
		require("mini.bufremove").delete(buf == 0 and vim.api.nvim_get_current_buf() or buf, force or false)
	else
		local cmd = (force and "bdelete!" or "bdelete")
		if buf == 0 then
			-- buffer courant -> ne PAS ajouter " 0"
			vim.cmd(cmd)
		else
			vim.cmd(cmd .. " " .. buf)
		end
	end
end

local function listed_buffers()
	local infos = vim.fn.getbufinfo({ buflisted = 1 })
	table.sort(infos, function(a, b)
		return a.bufnr < b.bufnr
	end)
	return infos
end

local function close_others()
	local cur = vim.api.nvim_get_current_buf()
	for _, info in ipairs(listed_buffers()) do
		if info.bufnr ~= cur then
			buf_delete(info.bufnr, false)
		end
	end
end

local function close_left_right(side)
	local cur = vim.api.nvim_get_current_buf()
	local infos = listed_buffers()
	local cur_idx
	for i, info in ipairs(infos) do
		if info.bufnr == cur then
			cur_idx = i
			break
		end
	end
	if not cur_idx then
		return
	end
	local range = (side == "left") and { 1, cur_idx - 1 } or { cur_idx + 1, #infos }
	for i = range[1], range[2] do
		local b = infos[i] and infos[i].bufnr
		if b then
			buf_delete(b, false)
		end
	end
end

-- Scroll des fenêtres LSP de noice (hover/signature) avec fallback natif
vim.keymap.set({ "n", "i", "s" }, "<C-f>", function()
	if not require("noice.lsp").scroll(4) then
		return "<C-f>" -- page down normal si pas de popup noice scrollable
	end
end, { silent = true, expr = true, desc = "Noice LSP scroll forward" })

vim.keymap.set({ "n", "i", "s" }, "<C-b>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<C-b>" -- page up normal si pas de popup noice scrollable
	end
end, { silent = true, expr = true, desc = "Noice LSP scroll backward" })

-- =========================
-- GÉNÉRALES
-- =========================
function M.apply_general()
	-- Effacer le highlight de recherche
	map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "No HL search" })

	-- Fenêtres → Alt-h/j/k/l (libère Ctrl-h/l pour les buffers)
	for lhs, dir in pairs({
		["<M-h>"] = "h",
		["<M-j>"] = "j",
		["<M-k>"] = "k",
		["<M-l>"] = "l",
	}) do
		map({ "n", "t" }, lhs, function()
			nav_win(dir)
		end, { desc = "Window " .. dir })
	end

	-- ===== Buffers (simple et compatible lualine tabline) =====
	-- Rapides
	map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Buffer précédent" })
	map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Buffer suivant" })

	-- Groupe <leader>b
	map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer: suivant" })
	map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Buffer: précédent" })

	map("n", "<leader>bd", function()
		buf_delete(0, false)
	end, { desc = "Buffer: fermer" })
	map("n", "<leader>bD", function()
		buf_delete(0, true)
	end, { desc = "Buffer: fermer (force)" })

	map("n", "<leader>bo", close_others, { desc = "Buffer: fermer autres" })
	map("n", "<leader>bh", function()
		close_left_right("left")
	end, { desc = "Buffer: fermer à gauche" })
	map("n", "<leader>bl", function()
		close_left_right("right")
	end, { desc = "Buffer: fermer à droite" })

	-- Picker (utilise Telescope si dispo, sinon :ls -> :b)
	map("n", "<leader>bb", function()
		local ok = pcall(require, "telescope.builtin")
		if ok then
			require("telescope.builtin").buffers()
		else
			vim.cmd("ls")
			vim.cmd("redraw | echo 'Tapez :b <num>'")
		end
	end, { desc = "Buffers: picker" })

	-- ===== Lazy
	map("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Lazy: home" })
	map("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Lazy: update" })
	map("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Lazy: sync" })
	map("n", "<leader>lc", "<cmd>Lazy check<CR>", { desc = "Lazy: check" })
	map("n", "<leader>lC", "<cmd>Lazy clean<CR>", { desc = "Lazy: clean" })
	map("n", "<leader>lp", "<cmd>Lazy profile<CR>", { desc = "Lazy: profile" })

	-- ===== Dashboard (Alpha)
	local function dashboard_open()
		pcall(vim.cmd, "Alpha")
	end
	local function dashboard_only()
		vim.cmd("silent! %bd!")
		vim.schedule(function()
			pcall(vim.cmd, "Alpha")
			vim.cmd("only")
		end)
	end
	local function dashboard_toggle()
		if vim.bo.filetype == "alpha" then
			vim.cmd("b#")
		else
			pcall(vim.cmd, "Alpha")
			vim.cmd("only")
		end
	end

	map("n", "<leader>dd", dashboard_open, { desc = "Dashboard: open" })
	map("n", "<leader>dD", dashboard_only, { desc = "Dashboard: close all & open" })
	map("n", "<leader>dt", dashboard_toggle, { desc = "󰕮 Dashboard: toggle" })
	map("n", "<leader>dR", "<cmd>AlphaRedraw<CR>", { desc = "Dashboard: redraw" })
	map("n", "<leader>dq", "<cmd>qa<CR>", { desc = "Quit all" })

	-- ===== AI (Which-Key: <leader>a)
	local wk_ok, wk = pcall(require, "which-key")
	if wk_ok then
		wk.add({ { "<leader>a", group = "AI" } })
	end

	-- Toggle source Copilot dans cmp
	map("n", "<leader>aa", function()
		require("config.ai_toggle").toggle()
	end, { desc = "Copilot in cmp: toggle" })
	map("n", "<leader>ae", function()
		require("config.ai_toggle").enable()
	end, { desc = "Copilot in cmp: enable" })
	map("n", "<leader>ad", function()
		require("config.ai_toggle").disable()
	end, { desc = "Copilot in cmp: disable" })

	-- Copilot Chat
	map("n", "<leader>ac", "<cmd>CopilotChatToggle<CR>", { desc = "Chat: toggle" })
	map("n", "<leader>ap", "<cmd>CopilotChatPrompts<CR>", { desc = "Chat: prompts" })
	map("n", "<leader>am", "<cmd>CopilotChatModels<CR>", { desc = "Chat: models" })
	map("n", "<leader>ar", "<cmd>CopilotChat Review<CR>", { desc = "Chat: review buffer" })
	map("v", "<leader>ax", ":CopilotChat Explain<CR>", { desc = "Chat: explain selection" })
	map("v", "<leader>af", ":CopilotChat Fix<CR>", { desc = "Chat: fix selection" })
	map("n", "<leader>aR", "<cmd>CopilotChatReset<CR>", { desc = "Chat: reset" })

	-- ===== Zettelkasten (zk) =====
	local zk = require("config.zk")
	map("n", "<leader>zn", zk.new_note, { desc = "ZK: nouvelle note (titre…)" })
	map("n", "<leader>zd", zk.new_daily, { desc = "ZK: journal du jour" })
	map("n", "<leader>zs", zk.browse, { desc = "ZK: parcourir (Telescope)" })
	map("n", "<leader>zr", zk.recents, { desc = "ZK: récents (2 semaines)" })
	map("n", "<leader>zt", zk.tags, { desc = "ZK: tags" })
	map("n", "<leader>zb", zk.backlinks, { desc = "ZK: backlinks (buffer)" })
	map("n", "<leader>zl", zk.links, { desc = "ZK: liens sortants (buffer)" })
	map("n", "<leader>zg", zk.grep, { desc = "ZK: recherche plein-texte" })
	map("n", "<leader>zi", zk.insert_link_cursor, { desc = "ZK: insérer lien" })
	map("v", "<leader>zi", zk.insert_link_visual, { desc = "ZK: lien depuis sélection" })

	-- ===== Learn / Training =====
	local learn = {} -- helpers inline si besoin plus tard

	-- Cheatsheet (via Telescope)
	map("n", "<leader>?", "<cmd>Cheatsheet<CR>", { desc = "Cheatsheet: open" })

	-- VimBeGood (jeu)
	map("n", "<leader>tv", "<cmd>VimBeGood<CR>", { desc = "VimBeGood (train)" })

	-- Hardtime (coach)
	map("n", "<leader>th", "<cmd>Hardtime toggle<CR>", { desc = "Hardtime toggle" })

	-- Treesitter Playground
	map("n", "<leader>tp", "<cmd>TSPlaygroundToggle<CR>", { desc = "TS Playground" })
	map("n", "<leader>tH", "<cmd>TSHighlightCapturesUnderCursor<CR>", { desc = "Highlight captures" })

	-- Undo tree (Telescope)
	map("n", "<leader>tu", "<cmd>Telescope undo<CR>", { desc = "Undo tree" })

	-- Marks (liste rapide)
	map("n", "<leader>tm", "<cmd>MarksListBuf<CR>", { desc = "Marks (buffer)" })
	map("n", "<leader>tM", "<cmd>MarksListAll<CR>", { desc = "Marks (all)" })

	-- Hydra Fenêtres (ouverture guidée)
	map("n", "<leader>tW", function()
		require("config.hydras").windows()
	end, { desc = "Windows Hydra" })
	-- (alias direct si tu veux garder l’habitude)
	map("n", "<leader>W", function()
		require("config.hydras").windows()
	end, { desc = "Windows Hydra" })
end

-- =========================
-- LSP (buffer-local)
-- =========================
function M.lsp(bufnr)
	local b = { buffer = bufnr, silent = true }
	local function mapb(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", { desc = desc }, b))
	end

	-- LSP de base
	mapb("n", "gd", vim.lsp.buf.definition, "LSP: definition")
	mapb("n", "gr", vim.lsp.buf.references, "LSP: references")
	mapb("n", "K", vim.lsp.buf.hover, "LSP: hover")
	mapb("n", "<leader>cr", vim.lsp.buf.rename, "LSP: rename")
	mapb({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
	mapb("n", "<leader>cf", function()
		if pcall(require, "conform") then
			require("conform").format({ lsp_fallback = true })
		else
			vim.lsp.buf.format({ async = true })
		end
	end, "Format buffer")

	-- === Diagnostics (flottant + liste) ===

	-- Ouvrir un DIAGNOSTIC FLOTTANT pour la position courante
	-- (Noice stylise le contenu si lsp.override est activé)
	mapb("n", "<leader>cd", function()
		vim.diagnostic.open_float(nil, {
			focus = false, -- ne vole pas le focus
			scope = "cursor", -- "cursor" = diag sous le curseur (ou "line")
			border = "rounded",
			source = "if_many",
			severity_sort = true,
		})
	end, "Diag: flottant (courant)")

	-- Suivant / précédent (inchangé)
	mapb("n", "]d", function()
		vim.diagnostic.goto_next({ float = false })
	end, "Diag: suivant")
	mapb("n", "[d", function()
		vim.diagnostic.goto_prev({ float = false })
	end, "Diag: précédent")

	-- Liste diagnostics (Trouble si présent, sinon loclist)
	mapb("n", "<leader>cD", function()
		local ok, trouble = pcall(require, "trouble")
		if ok then
			trouble.open("diagnostics")
		else
			vim.diagnostic.setloclist({ open = true })
		end
	end, "Diag: liste (Trouble/QF)")
end
-- =========================
-- Clés destinées aux specs lazy
-- (lazy-load par touche)
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
		{ "<leader>fp", "<cmd>Telescope workspaces<CR>", desc = "Find: workspaces" },
	},
	explorer = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer: toggle" },
		{ "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Explorer: reveal file" },
	},
	git = {
		lazygit = {
			{ "<leader>gl", "<cmd>LazyGit<CR>", desc = "Git: LazyGit" },
		},
		gitsigns = {
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
		diffview = {
			{ "<leader>gdo", "<cmd>DiffviewOpen<CR>", desc = "Git: Diffview open" },
			{ "<leader>gdc", "<cmd>DiffviewClose<CR>", desc = "Git: Diffview close" },
			{ "<leader>gdh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: file history (buffer)" },
			{ "<leader>gdH", "<cmd>DiffviewFileHistory<CR>", desc = "Git: repo history" },
		},
	},
}

-- Hints which-key
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		M.apply_general()
		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>?", desc = "Cheatsheet: open", icon = { icon = " ", color = "red" } },
				{ "<leader>c", group = "Code / LSP" },
				{ "<leader>f", group = "Find (Telescope)" },
				{ "<leader>g", group = "Git" },
				{ "<leader>b", group = "Buffers" },
				{ "<leader>l", group = "Lazy" },
				{ "<leader>d", group = "Dashboard", icon = { icon = " ", color = "purple" } },
				{ "<leader>p", group = "Projects / Workspaces" },
				{ "<leader>z", group = "Zettelkasten (zk)", icon = { icon = " ", color = "yellow" } },
				{ "<leader>t", group = "Learn / Training", icon = { icon = "", color = "green" } }, -- icône which-key
				-- Buffers
				{ "<leader>bn", desc = "Suivant" },
				{ "<leader>bp", desc = "Précédent" },
				{ "<leader>bb", desc = "Picker" },
				{ "<leader>bd", desc = "Fermer" },
				{ "<leader>bD", desc = "Fermer (force)" },
				{ "<leader>bo", desc = "Fermer autres" },
				{ "<leader>bh", desc = "Fermer à gauche" },
				{ "<leader>bl", desc = "Fermer à droite" },
				-- Zk
				{ "<leader>zn", desc = "Nouvelle note (titre…)" },
				{ "<leader>zd", desc = "Journal du jour" },
				{ "<leader>zs", desc = "Parcourir (Telescope)" },
				{ "<leader>zr", desc = "Récents (2 semaines)" },
				{ "<leader>zt", desc = "Tags" },
				{ "<leader>zb", desc = "Backlinks (buffer)" },
				{ "<leader>zl", desc = "Liens sortants (buffer)" },
				{ "<leader>zg", desc = "Recherche plein-texte" },
				{ "<leader>zi", desc = "Insérer lien" },
			})
			-- --- Which-Key: nvim-surround ------------------------------------------------
			-- n’affiche les hints que si which-key ET nvim-surround sont chargés
			do
				local ok_wk, wk = pcall(require, "which-key")
				if ok_wk and package.loaded["nvim-surround"] then
					-- NORMAL mode: préfixes y / d / c
					wk.add({
						{ "y", group = "Yank / Surround" },
						{ "ys", desc = "Surround: add (motion)" },
						{ "yS", desc = "Surround: add (line)" },
						{ "yss", desc = "Surround: add to line" },
						{ "ySS", desc = "Surround: add to line (cur)" },

						{ "d", group = "Delete / Surround" },
						{ "ds", desc = "Surround: delete" },

						{ "c", group = "Change / Surround" },
						{ "cs", desc = "Surround: change" },
					}, { mode = "n", nowait = true })

					-- VISUAL mode: selon ta conf (S ou gS)
					wk.add({
						{ "S", desc = "Surround: add (visual)" },
						{ "gS", desc = "Surround: add (visual alt)" }, -- garde si tu utilises gS
					}, { mode = "x", nowait = true })
				end
			end
		end
	end,
})

return M
