-- https://github.com/goolord/alpha-nvim
return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local alpha = require("alpha")
		local dash = require("alpha.themes.dashboard")
		local tb = require("telescope.builtin")

		-- Header custom
		dash.section.header.val = {
			"⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"                      ⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"                  ⠀⠀⠀⠀⠀⠀⣀⡴⢧⣀⠀⠀⣀⣠⠤⠤⠤⠤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"                  ⠀⠀⠀⠀⠀⠀⠀⠘⠏⢀⡴⠊⠁⠀⠀⠀⠀⠀⠀⠈⠙⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"                     ⠀⠀⠀⠀⠀⣰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢶⣶⣒⣶⠦⣤⣀⠀⠀",
			"                     ⠀⠀⠀⢀⣰⠃⠀⠀⠀       ⠀⠀⠀⠀⠈⣟⠲⡌⠙⢦⠈⢧⠀",
			"                  ⠀⠀⠀⣠⢴⡾⢟⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡴⢃⡠⠋⣠⠋⠀",
			"                  ⠐⠀⠞⣱⠋⢰⠁⢿⠀⠀⠀⠀       ⣀⣠⠤⢖⣋⡥⢖⣫⠔⠋⠀⠀⠀",
			"                  ⠈⠠⡀⠹⢤⣈⣙⠚⠶⠤⠤⠤⠴⠶⣒⣒⣚⣩⠭⢵⣒⣻⠭⢖⠏⠁⢀⣀⠀⠀⠀⠀",
			"                  ⠠⠀⠈⠓⠒⠦⠭⠭⠭⣭⠭⠭⠭⠭⠿⠓⠒⠛⠉⠉⠀⠀⣠⠏⠀⠀⠘⠞⠀⠀⠀⠀",
			"  ⠀          ⠀⠀      ⠀⠀⠀⠀⠀⠀⠈⠓⢤⣀⠀⠀⠀⠀⠀⠀⣀⡤⠞⠁⠀⣰⣆⠀⠀⠀⠀⠀⠀",
			"                   ⠀⠀⠀⠀⠘⠿⠀⠀⠀⠀⠀⠈⠉⠙⠒⠒⠛⠉⠁⠀⠀⠀⠉⢳⡞⠉⠀⠀⠀⠀⠀",
			" ",
			"                                 nebulix⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"                                              ",
			"       ████ ██████           █████      ██",
			"      ███████████             █████ ",
			"      █████████ ███████████████████ ███   ███████████",
			"     █████████  ███    █████████████ █████ ██████████████",
			"    █████████ ██████████ █████████ █████ █████ ████ █████",
			"  ███████████ ███    ███ █████████ █████ █████ ████ █████",
			" ██████  █████████████████████ ████ █████ █████ ████ ██████",
			" ",
		}
		-- Boutons du haut
		dash.section.buttons.val = {
			dash.button("l", "󰒲  Lazy", ":Lazy<CR>"),
			dash.button("f", "  Files", ":Telescope find_files<CR>"),
			dash.button("g", "  Grep", ":Telescope live_grep<CR>"),
			dash.button("p", "  Projects", ":Telescope projects<CR>"),
			dash.button("s", "  Store", ":Store<CR>"),
			dash.button(
				"d",
				"  Dotfiles",
				[[<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.expand('~/dotfiles') })<CR>]]
			),
			dash.button(
				"c",
				"  Config",
				[[<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })<CR>]]
			),
			dash.button("q", "󰗼  Quit", ":qa<CR>"),
		}

		-- MRU maison (pas de dashboard.file_button)
		local function mru_section(opts)
			opts = vim.tbl_extend("force", { max = 10, cwd = nil, title = "Recent files" }, opts or {})

			-- helper: crée un bouton fichier
			local function file_btn(idx, path)
				local short = vim.fn.fnamemodify(path, ":.")
				short = vim.fn.pathshorten(short)
				local cmd = string.format("<cmd>e %s<CR>", vim.fn.fnameescape(path))
				local btn = dash.button(tostring(idx), short, cmd)
				btn.opts.hl_shortcut = "Number"
				return btn
			end

			-- filtre et collecte
			local rootspec = opts.cwd and (vim.fn.fnamemodify(opts.cwd, ":p")) or nil
			local files, count = {}, 0
			for _, p in ipairs(vim.v.oldfiles or {}) do
				if vim.fn.filereadable(p) == 1 then
					if not rootspec or p:sub(1, #rootspec) == rootspec then
						count = count + 1
						table.insert(files, p)
						if count >= opts.max then
							break
						end
					end
				end
			end

			-- construit le group
			local buttons = {}
			for i, p in ipairs(files) do
				table.insert(buttons, file_btn(i, p))
			end

			return {
				type = "group",
				val = vim.tbl_extend("force", {
					{ type = "padding", val = 1 },
					{ type = "text", val = opts.title, opts = { hl = "SpecialComment", position = "center" } },
					{ type = "padding", val = 1 },
				}, buttons),
				opts = { position = "center" },
			}
		end

		dash.config.layout = {
			{ type = "padding", val = 1 },
			dash.section.header,
			{ type = "padding", val = 1 },
			dash.section.buttons,
			{ type = "padding", val = 1 },
			mru_section({ max = 8 }), -- MRU global
			-- mru_section({ max = 8, cwd = vim.fn.getcwd(), title = "Recent in CWD" }), -- variante CWD
		}
		local function make_footer()
			local v = vim.version()
			local ver = string.format(" v%d.%d.%d", v.major, v.minor, v.patch)

			local plugins, ms = 0, 0
			local ok, lazy = pcall(require, "lazy")
			if ok then
				local s = lazy.stats()
				plugins = s.count or 0
				ms = s.startuptime or 0
			end

			local when = os.date("%a %d %b %H:%M") -- ex: mar 04 sep 11:42
			return string.format("%s  •  %s  •  %d plugins in %dms", ver, when, plugins, math.floor(ms))
		end

		dash.section.footer.val = make_footer()
		dash.section.footer.opts = { position = "center", hl = "Comment" }
		-- ============================================================

		dash.config.layout = {
			{ type = "padding", val = 1 },
			dash.section.header,
			{ type = "padding", val = 1 },
			dash.section.buttons,
			{ type = "padding", val = 1 },
			mru_section({ max = 8 }), -- ta section MRU maison
			{ type = "padding", val = 1 },
			dash.section.footer, -- <<< ajoute le footer dans le layout
		}

		alpha.setup(dash.config)
	end,
}
