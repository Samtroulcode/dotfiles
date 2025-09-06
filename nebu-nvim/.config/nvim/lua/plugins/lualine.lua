return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		-- Palette
		local colors = {
			blue = "#80a0ff",
			cyan = "#79dac8",
			black = "#080808",
			white = "#c6c6c6",
			red = "#ff5189",
			violet = "#d183e8",
			grey = "#303030",
		}

		-- Thème bulles
		local bubbles_theme = {
			normal = {
				a = { fg = colors.black, bg = colors.violet },
				b = { fg = colors.white, bg = colors.grey },
				c = { fg = colors.white },
			},
			insert = { a = { fg = colors.black, bg = colors.blue } },
			visual = { a = { fg = colors.black, bg = colors.cyan } },
			replace = { a = { fg = colors.black, bg = colors.red } },
			inactive = {
				a = { fg = colors.white, bg = colors.black },
				b = { fg = colors.white, bg = colors.black },
				c = { fg = colors.white },
			},
		}

		-- Helpers/Composants
		local function cwd()
			local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			return " " .. dir
		end

		local function gitsigns_diff_source()
			-- attend que gitsigns ait rempli b:gitsigns_status_dict
			return vim.b.gitsigns_status_dict
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			update_in_insert = false,
			always_visible = false,
		}

		local git_branch = { "branch", icon = "" }
		local git_diff = {
			"diff",
			source = gitsigns_diff_source,
			symbols = { added = " ", modified = " ", removed = " " },
		}

		local function lsp_names()
			local buf = vim.api.nvim_get_current_buf()
			local clients = vim.lsp.get_clients({ bufnr = buf })
			if #clients == 0 then
				return ""
			end
			local names = {}
			for _, c in ipairs(clients) do
				table.insert(names, c.name)
			end
			return " " .. table.concat(names, ",")
		end

		local function ts_ok()
			local ok = pcall(vim.treesitter.get_parser, 0)
			return ok and "󰐅 TS" or ""
		end

		local function macro_rec()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end
			return " @" .. reg
		end

		local function searchcount()
			if vim.v.hlsearch == 0 then
				return ""
			end
			local sc = vim.fn.searchcount({ maxcount = 999, timeout = 50 })
			if sc.total == 0 then
				return ""
			end
			return string.format(" %d/%d", sc.current or 0, sc.total or 0)
		end

		local function indent()
			return "␠" .. vim.api.nvim_get_option_value("shiftwidth", { scope = "local" })
		end

		local function enc_ff()
			local e = (vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc):lower()
			local f = vim.bo.fileformat
			local out = {}
			if e ~= "utf-8" then
				table.insert(out, e)
			end
			if f ~= "unix" then
				table.insert(out, f)
			end
			return #out > 0 and table.concat(out, "·") or ""
		end

		local function dap_status()
			local ok, dap = pcall(require, "dap")
			if not ok then
				return ""
			end
			local s = dap.status()
			return (s and s ~= "") and (" " .. s) or ""
		end

		local function copilot_status()
			local ok, client = pcall(function()
				return require("copilot.client")
			end)
			if not ok then
				return ""
			end
			local attached = false
			for _, c in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
				if c.name == "copilot" then
					attached = true
					break
				end
			end
			return attached and " Copilot" or ""
		end

		-- composant centré séparateur
		local align = "%="

		return {
			options = {
				theme = bubbles_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = {}, winbar = {} },
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = { cwd, git_branch, git_diff },
				lualine_c = { diagnostics, align, lsp_names, ts_ok, dap_status, copilot_status },
				lualine_x = { searchcount, macro_rec },
				lualine_y = { indent, { "filetype", icon_only = false }, enc_ff, "progress" },
				lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			-- Petit “bufferline” via tabline (si tu ne veux pas un plugin dédié)
			tabline = {
				lualine_a = { { "buffers", symbols = { modified = " ●", alternate_file = "" }, mode = 2 } },
				lualine_z = { { "tabs", mode = 2 } },
			},
			extensions = { "neo-tree", "quickfix", "fugitive", "trouble", "toggleterm" },
		}
	end,
}
