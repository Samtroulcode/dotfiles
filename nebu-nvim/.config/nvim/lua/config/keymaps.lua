-- lua/config/keymaps.lua
-- Refactor lisible/robuste, mêmes fonctionnalités

local M = {}
local map = vim.keymap.set
local current_transparent = true

-- ---------- Utils ----------
local function has(mod)
	return package.loaded[mod] or pcall(require, mod)
end

local function try(require_path)
	local ok, mod = pcall(require, require_path)
	return ok and mod or nil
end

local function mapx(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	map(mode, lhs, rhs, opts)
end

-- Permet de toggle l'opacité ou non
function ToggleTransparency()
	current_transparent = not current_transparent
	require("catppuccin").setup({
		transparent_background = current_transparent,
	})
	vim.cmd.colorscheme("catppuccin")
	print("Transparency: " .. tostring(current_transparent))
end

-- -- -- Workspace root detection (LSP > project_nvim > git > cwd)
local function get_project_root()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, c in ipairs(clients) do
		local ws = c.config.workspace_folders
		local root = (ws and ws[1] and ws[1].name) or c.config.root_dir
		if root and root ~= "" then
			return root
		end
	end
	local ok_proj, project = pcall(require, "project_nvim.project")
	if ok_proj and project.get_project_root then
		local r = project.get_project_root()
		if r and r ~= "" then
			return r
		end
	end
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if git_root and git_root ~= "" then
		return git_root
	end
	return vim.loop.cwd()
end

local function telescope_files_workspace()
	local root = get_project_root()
	require("telescope.builtin").find_files({
		cwd = root,
		hidden = true,
		follow = true,
	})
end

local function telescope_grep_workspace()
	local root = get_project_root()
	require("telescope.builtin").live_grep({
		cwd = root,
		additional_args = function(_)
			return {
				"--hidden",
				"--glob",
				"!.git/**",
				"--glob",
				"!node_modules/**",
				"--glob",
				"!dist/**",
				"--glob",
				"!build/**",
				"--glob",
				"!target/**",
			}
		end,
	})
end

-- Normal mode (nav)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Terminal mode (exit + nav)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])

-- Redimensionner plus vite
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- ---------- Buffers helpers ----------
local function buf_delete(buf, force)
	buf = buf or 0
	if has("mini.bufremove") then
		require("mini.bufremove").delete(buf == 0 and vim.api.nvim_get_current_buf() or buf, force or false)
	else
		vim.api.nvim_buf_delete(buf == 0 and vim.api.nvim_get_current_buf() or buf, { force = force or false })
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
	local infos, cur_idx = listed_buffers(), nil
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

-- ---------- Noice LSP scroll (protégé si noice absent) ----------
do
	local noice_lsp = try("noice.lsp")
	mapx({ "n", "i", "s" }, "<C-f>", function()
		if noice_lsp and noice_lsp.scroll(4) then
			return ""
		end
		return "<C-f>"
	end, { expr = true, desc = "Noice LSP scroll forward" })

	mapx({ "n", "i", "s" }, "<C-b>", function()
		if noice_lsp and noice_lsp.scroll(-4) then
			return ""
		end
		return "<C-b>"
	end, { expr = true, desc = "Noice LSP scroll backward" })
end

-- ===================================================================
-- GÉNÉRAL
-- ===================================================================
function M.apply_general()
	-- Clear search highlight
	mapx("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "No HL search" })

	-- Navigation de fenêtres : Alt-h/j/k/l
	for lhs, dir in pairs({
		["<M-Up>"] = "h",
		["<M-Down>"] = "j",
		["<M-k>"] = "k",
		["<M-l>"] = "l",
	}) do
		mapx({ "n", "t" }, lhs, function()
			nav_win(dir)
		end, { desc = "Window " .. dir })
	end

	-- Buffers (Tab / S-Tab rapides)
	mapx("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Buffer suivant" })
	mapx("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Buffer précédent" })

	-- Groupe <leader>b
	mapx("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer: suivant" })
	mapx("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Buffer: précédent" })
	mapx("n", "<leader>bd", function()
		buf_delete(0, false)
	end, { desc = "Buffer: fermer" })
	mapx("n", "<leader>bD", function()
		buf_delete(0, true)
	end, { desc = "Buffer: fermer (force)" })
	mapx("n", "<leader>bo", close_others, { desc = "Buffer: fermer autres" })
	mapx("n", "<leader>bh", function()
		close_left_right("left")
	end, { desc = "Buffer: fermer à gauche" })
	mapx("n", "<leader>bl", function()
		close_left_right("right")
	end, { desc = "Buffer: fermer à droite" })

	-- Buffer picker (Telescope si dispo, sinon ls)
	mapx("n", "<leader>bb", function()
		local tb = try("telescope.builtin")
		if tb then
			tb.buffers()
		else
			vim.cmd("ls | redraw | echo 'Tapez :b <num>'")
		end
	end, { desc = "Buffers: picker" })

	-- Lazy
	mapx("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Lazy: home" })
	mapx("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Lazy: update" })
	mapx("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Lazy: sync" })
	mapx("n", "<leader>lc", "<cmd>Lazy check<CR>", { desc = "Lazy: check" })
	mapx("n", "<leader>lC", "<cmd>Lazy clean<CR>", { desc = "Lazy: clean" })
	mapx("n", "<leader>lp", "<cmd>Lazy profile<CR>", { desc = "Lazy: profile" })

	-- Dashboard (Alpha)
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
	mapx("n", "<leader>dd", dashboard_open, { desc = "Dashboard: open" })
	mapx("n", "<leader>dD", dashboard_only, { desc = "Dashboard: close all & open" })
	mapx("n", "<leader>dt", dashboard_toggle, { desc = "󰕮 Dashboard: toggle" })
	mapx("n", "<leader>dR", "<cmd>AlphaRedraw<CR>", { desc = "Dashboard: redraw" })
	mapx("n", "<leader>dq", "<cmd>qa<CR>", { desc = "Quit all" })

	-- Which-key groups (création légère, safe si which-key absent)
	do
		local wk = try("which-key")
		if wk and wk.add then
			wk.add({
				{ "<leader>a", group = "Copilot", icon = { icon = " ", color = "cyan" } },
				{ "<leader>c", group = "Code / LSP" },
				{ "<leader>f", group = "Find (Telescope)" },
				{ "<leader>g", group = "Git" },
				{ "<leader>b", group = "Buffers", icon = { icon = " ", color = "magenta" } },
				{ "<leader>l", group = "Lazy" },
				{ "<leader>d", group = "Dashboard", icon = { icon = " ", color = "purple" } },
				{ "<leader>p", group = "Projects / Workspaces", icon = { icon = " ", color = "blue" } },
				{ "<leader>z", group = "Zettelkasten (zk)", icon = { icon = " ", color = "yellow" } },
				{ "<leader>t", group = "Learn / Training", icon = { icon = " ", color = "green" } },
				{ "<leader>?", desc = "Cheatsheet: open", icon = { icon = " ", color = "red" } },
			})
		end
	end

	-- Global (respecte .gitignore + hidden)
	mapx("n", "<leader>ff", function()
		local tb = try("telescope.builtin")
		if not tb then
			return
		end
		tb.find_files({ hidden = true, follow = true })
	end, { desc = "Telescope: files (global)" })

	mapx("n", "<leader>fg", function()
		local tb = try("telescope.builtin")
		if not tb then
			return
		end
		tb.live_grep() -- exclusions passées via additional_args si besoin
	end, { desc = "Telescope: live grep (global)" })

	-- Workspace courant (projet)
	mapx("n", "<leader>fF", telescope_files_workspace, { desc = "Telescope: files (workspace)" })
	mapx("n", "<leader>fG", telescope_grep_workspace, { desc = "Telescope: grep (workspace)" })

	-- Pickers utiles
	mapx("n", "<leader>fr", function()
		require("telescope.builtin").resume()
	end, { desc = "Telescope: resume" })
	mapx("n", "<leader>fs", function()
		require("telescope.builtin").grep_string()
	end, { desc = "Telescope: grep <cword>" })
	mapx("v", "<leader>fs", function()
		require("telescope.builtin").grep_string({ use_regex = false, search = vim.fn.getreg("v") })
	end, { desc = "Telescope: grep selection" })
	mapx("n", "<leader>f.", function()
		require("telescope.builtin").oldfiles()
	end, { desc = "Telescope: recent files" })
	mapx("n", "<leader>f/", function()
		require("telescope.builtin").search_history()
	end, { desc = "Telescope: search history" })
	mapx("n", "<leader>fk", function()
		require("telescope.builtin").keymaps()
	end, { desc = "Telescope: keymaps" })
	mapx("n", "<leader>f:", function()
		require("telescope.builtin").command_history()
	end, { desc = "Telescope: cmd history" })
	mapx("n", "<leader>fd", function()
		require("telescope.builtin").diagnostics({ bufnr = 0 })
	end, { desc = "Telescope: diagnostics (buffer)" })
	mapx("n", "<leader>fD", function()
		require("telescope.builtin").diagnostics()
	end, { desc = "Telescope: diagnostics (workspace)" })
	mapx("n", "<leader>fS", function()
		require("telescope.builtin").lsp_document_symbols()
	end, { desc = "Telescope: symbols (doc)" })
	mapx("n", "<leader>fW", function()
		require("telescope.builtin").lsp_workspace_symbols()
	end, { desc = "Telescope: symbols (ws)" })

	-- Git (fallback auto si hors repo)
	mapx("n", "<leader>fgf", function()
		local tb = try("telescope.builtin")
		if not tb then
			return
		end
		local ok = (vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1] == "true")
		if ok then
			tb.git_files({ show_untracked = true })
		else
			tb.find_files({ hidden = true, follow = true })
		end
	end, { desc = "Telescope: git_files or files" })

	-- AI (toggle de ta source Copilot dans cmp)
	mapx("n", "<leader>aa", function()
		require("config.ai_toggle").toggle()
	end, { desc = "Copilot in cmp: toggle" })
	mapx("n", "<leader>ae", function()
		require("config.ai_toggle").enable()
	end, { desc = "Copilot in cmp: enable" })
	mapx("n", "<leader>ad", function()
		require("config.ai_toggle").disable()
	end, { desc = "Copilot in cmp: disable" })

	-- Copilot Chat
	mapx("n", "<leader>ac", "<cmd>CopilotChatToggle<CR>", { desc = "Chat: toggle" })
	mapx("n", "<leader>ap", "<cmd>CopilotChatPrompts<CR>", { desc = "Chat: prompts" })
	mapx("n", "<leader>am", "<cmd>CopilotChatModels<CR>", { desc = "Chat: models" })
	mapx("n", "<leader>ar", "<cmd>CopilotChat Review<CR>", { desc = "Chat: review buffer" })
	mapx("v", "<leader>ax", ":CopilotChat Explain<CR>", { desc = "Chat: explain selection" })
	mapx("v", "<leader>af", ":CopilotChat Fix<CR>", { desc = "Chat: fix selection" })
	mapx("n", "<leader>aR", "<cmd>CopilotChatReset<CR>", { desc = "Chat: reset" })

	-- Zettelkasten (zk)
	do
		local zk = require("config.zk")
		mapx("n", "<leader>zn", zk.new_note, { desc = "ZK: nouvelle note (titre…)" })
		mapx("n", "<leader>zd", zk.new_daily, { desc = "ZK: journal du jour" })
		mapx("n", "<leader>zs", zk.browse, { desc = "ZK: parcourir (Telescope)" })
		mapx("n", "<leader>zr", zk.recents, { desc = "ZK: récents (2 semaines)" })
		mapx("n", "<leader>zt", zk.tags, { desc = "ZK: tags" })
		mapx("n", "<leader>zb", zk.backlinks, { desc = "ZK: backlinks (buffer)" })
		mapx("n", "<leader>zl", zk.links, { desc = "ZK: liens sortants (buffer)" })
		mapx("n", "<leader>zg", zk.grep, { desc = "ZK: recherche plein-texte" })
		mapx("n", "<leader>zi", zk.insert_link_cursor, { desc = "ZK: insérer lien" })
		mapx("v", "<leader>zi", zk.insert_link_visual, { desc = "ZK: lien depuis sélection" })
	end

	-- Learn / Training
	mapx("n", "<leader>?", "<cmd>Cheatsheet<CR>", { desc = "Cheatsheet: open" })
	mapx("n", "<leader>Tv", "<cmd>VimBeGood<CR>", { desc = "VimBeGood (train)" })
	mapx("n", "<leader>Tu", "<cmd>Telescope undo<CR>", { desc = "Undo tree" })

	-- Neotest (Jest)
	local ok_nt, neotest = pcall(require, "neotest")
	if ok_nt then
		map("n", "<leader>tn", function()
			neotest.run.run()
		end, { desc = "Test: nearest" })
		map("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Test: file" })
		map("n", "<leader>ts", neotest.summary.toggle, { desc = "Test: summary" })
		map("n", "<leader>to", neotest.output.open, { desc = "Test: output" })
		map("n", "<leader>tO", function()
			neotest.output.open({ enter = true, short = false })
		end, { desc = "Test: output (float)" })
	end

	-- Sauter en gardant le curseur centré
	mapx("n", "n", "nzzzv", { desc = "Search next (center)" })
	mapx("n", "N", "Nzzzv", { desc = "Search prev (center)" })
	mapx("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

	-- Déplacement de lignes/selection (Alt + j/k)
	mapx("n", "<M-j>", ":m .+1<CR>==", { desc = "Move line down" })
	mapx("n", "<M-k>", ":m .-1<CR>==", { desc = "Move line up" })
	mapx("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
	mapx("v", "<M-k>", ":m '<-1<CR>gv=gv", { desc = "Move selection up" })

	-- Resize fenêtres rapide
	mapx("n", "<M-=>", "<cmd>resize +3<CR>", { desc = "Win taller" })
	mapx("n", "<M-->", "<cmd>resize -3<CR>", { desc = "Win shorter" })
	mapx("n", "<M-,>", "<cmd>vertical resize -6<CR>", { desc = "Win narrower" })
	mapx("n", "<M-.>", "<cmd>vertical resize +6<CR>", { desc = "Win wider" })

	-- Alternate file / dernier buffer visité
	mapx("n", "<leader><Tab>", "<C-^>", { desc = "Alternate file" })

	local function toggle(opt, on, off, name)
		local v = vim.opt_local[opt]:get()
		if (type(v) == "boolean" and v) or (type(v) ~= "boolean" and v ~= 0 and v ~= nil) then
			vim.opt_local[opt] = off or false
			vim.notify("Toggle " .. name .. ": OFF")
		else
			vim.opt_local[opt] = on or true
			vim.notify("Toggle " .. name .. ": ON")
		end
	end

	mapx("n", "<leader>Tw", function()
		toggle("wrap", true, false, "wrap")
	end, { desc = "Toggle wrap" })
	mapx("n", "<leader>Tr", function()
		toggle("relativenumber", true, false, "relativenumber")
	end, { desc = "Toggle relativenumber" })
	mapx("n", "<leader>Tl", function()
		toggle("list", true, false, "listchars")
	end, { desc = "Toggle listchars" })
	mapx("n", "<leader>Tc", function()
		toggle("colorcolumn", { "80" }, {}, "colorcolumn")
	end, { desc = "Toggle colorcolumn=80" })

	mapx("n", "<leader>Tt", ToggleTransparency, { desc = "Toggle transparency" })

	-- Spell FR/EN simple
	mapx("n", "<leader>Ts", function()
		if vim.opt_local.spell:get() and vim.opt_local.spelllang:get() == "fr" then
			vim.opt_local.spelllang = "en"
		else
			vim.opt_local.spell = true
			vim.opt_local.spelllang = "fr"
		end
		vim.notify("Spell: " .. table.concat(vim.opt_local.spelllang:get(), ","))
	end, { desc = "Toggle spell fr<->en" })

	-- Quickfix navigation
	mapx("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Quickfix: open" })
	mapx("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Quickfix: close" })
	mapx("n", "]q", "<cmd>cnext<CR>zz", { desc = "Quickfix: next" })
	mapx("n", "[q", "<cmd>cprev<CR>zz", { desc = "Quickfix: prev" })
end

-- ===================================================================
-- LSP (buffer-local)
-- ===================================================================
function M.lsp(bufnr)
	local b = { buffer = bufnr, silent = true }
	local function mapb(mode, lhs, rhs, desc)
		map(mode, lhs, rhs, vim.tbl_extend("keep", { desc = desc }, b))
	end

	-- Peek definition si lspsaga dispo, sinon fallback hover/definition
	mapb("n", "gp", function()
		local saga = try("lspsaga.peek")
		if saga and saga.definition then
			saga.definition(1)
		else
			vim.lsp.buf.definition()
		end
	end, "LSP: peek/definition")

	-- Toggle inlay hints (Neovim 0.10+)
	mapb("n", "<leader>ci", function()
		if vim.lsp.inlay_hint then
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		end
	end, "LSP: toggle inlay hints")

	-- Format-on-save toggle (buffer local)
	mapb("n", "<leader>cF", function()
		local grp = "FormatOnSave_" .. bufnr
		local exists = false
		for _, a in ipairs(vim.api.nvim_get_autocmds({ group = grp })) do
			exists = true
			break
		end
		if exists then
			pcall(vim.api.nvim_del_augroup_by_name, grp)
			vim.notify("Format on save: OFF")
		else
			local id = vim.api.nvim_create_augroup(grp, { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = id,
				buffer = bufnr,
				callback = function()
					local conform = try("conform")
					if conform then
						conform.format({ lsp_fallback = true })
					else
						vim.lsp.buf.format({ async = false })
					end
				end,
			})
			vim.notify("Format on save: ON")
		end
	end, "LSP: toggle format on save")

	mapb("n", "gd", vim.lsp.buf.definition, "LSP: definition")
	mapb("n", "gr", vim.lsp.buf.references, "LSP: references")
	mapb("n", "K", vim.lsp.buf.hover, "LSP: hover")
	mapb("n", "<leader>cr", vim.lsp.buf.rename, "LSP: rename")
	mapb({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")

	mapb("n", "<leader>cf", function()
		local conform = try("conform")
		if conform then
			conform.format({ lsp_fallback = true })
		else
			vim.lsp.buf.format({ async = true })
		end
	end, "Format buffer")

	-- Diagnostics (float + next/prev + liste)
	mapb("n", "<leader>cd", function()
		vim.diagnostic.open_float(nil, {
			focus = false,
			scope = "cursor",
			border = "rounded",
			source = "if_many",
			severity_sort = true,
		})
	end, "Diag: flottant (courant)")

	mapb("n", "]d", function()
		vim.diagnostic.goto_next({ float = false })
	end, "Diag: suivant")
	mapb("n", "[d", function()
		vim.diagnostic.goto_prev({ float = false })
	end, "Diag: précédent")

	mapb("n", "<leader>cD", function()
		local trouble = try("trouble")
		if trouble and trouble.open then
			trouble.open("diagnostics")
		else
			vim.diagnostic.setloclist({ open = true })
		end
	end, "Diag: liste (Trouble/QF)")

	-- Toggle diagnostics inline (virtual_text)
	mapb("n", "<leader>cv", function()
		local cfg = vim.diagnostic.config()
		local vt = cfg.virtual_text
		local currently_on = (vt == true) or (type(vt) == "table")
		if currently_on then
			vim.diagnostic.config({ virtual_text = false })
			vim.notify("Diagnostics inline: OFF")
		else
			vim.diagnostic.config({ virtual_text = { prefix = "●", spacing = 2, source = "if_many" } })
			vim.notify("Diagnostics inline: ON")
		end
	end, "Diag: inline (toggle)")
end

-- ===================================================================
-- Clés destinées aux specs lazy (pour lazy-load par touche)
-- ===================================================================
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

-- Which-key hints au démarrage “VeryLazy”
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		M.apply_general()
		local wk = try("which-key")
		if wk and wk.add then
			wk.add({
				-- on évite les icônes which-key non standard qui cassent parfois la palette
				{ "<leader>bn", desc = "Suivant" },
				{ "<leader>bp", desc = "Précédent" },
				{ "<leader>bb", desc = "Picker" },
				{ "<leader>bd", desc = "Fermer" },
				{ "<leader>bD", desc = "Fermer (force)" },
				{ "<leader>bo", desc = "Fermer autres" },
				{ "<leader>bh", desc = "Fermer à gauche" },
				{ "<leader>bl", desc = "Fermer à droite" },
				-- ZK
				{ "<leader>zn", desc = "Nouvelle note (titre…)" },
				{ "<leader>zd", desc = "Journal du jour" },
				{ "<leader>zs", desc = "Parcourir (Telescope)" },
				{ "<leader>zr", desc = "Récents (2 semaines)" },
				{ "<leader>zt", desc = "Tags" },
				{ "<leader>zb", desc = "Backlinks (buffer)" },
				{ "<leader>zl", desc = "Liens sortants (buffer)" },
				{ "<leader>zg", desc = "Recherche plein-texte" },
				{ "<leader>zi", desc = "Insérer lien" },
				-- QOL
				{ "<leader>T", group = "Toggles" },
				{ "<leader>q", group = "Quickfix" },
				{ "<leader>t", group = "Tests" },
				{ "<leader>f", group = "Find (Telescope)" },
				{ "<leader>tt", desc = "Terminal: toggle" },
				{ "<leader>fF", desc = "Files (workspace)" },
				{ "<leader>fG", desc = "Grep (workspace)" },
				-- Telescope
				{ "<leader>fS", desc = "Symbols (doc)" },
				{ "<leader>fW", desc = "Symbols (ws)" },
				{ "<leader>fd", desc = "Diagnostics (buf)" },
				{ "<leader>fD", desc = "Diagnostics (ws)" },
				{ "<leader>fr", desc = "Resume" },
				{ "<leader>fs", desc = "Grep word/selection" },
				{ "<leader>f.", desc = "Recent files" },
				{ "<leader>f/", desc = "Search history" },
				{ "<leader>fk", desc = "Keymaps" },
				{ "<leader>f:", desc = "Cmd history" },
				{ "<leader>fgf", desc = "Git files / Files" },
			})
			-- Hints nvim-surround (si chargé)
			if package.loaded["nvim-surround"] then
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
				wk.add({
					{ "S", desc = "Surround: add (visual)" },
					{ "gS", desc = "Surround: add (visual alt)" },
				}, { mode = "x", nowait = true })
			end
		end
	end,
})

return M
