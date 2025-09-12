-- lua/config/ai_toggle.lua
local M = {}
local enabled = true

-- renvoie ta liste de sources cmp de base SANS/AVEC copilot en tête
local function base_sources(with_copilot)
	local s = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer", keyword_length = 3, group_index = 2 },
		{ name = "npm" },
		{ name = "path" },
	}
	if with_copilot then
		table.insert(s, 1, { name = "copilot" })
	end
	return s
end

local function apply()
	local cmp = require("cmp")
	cmp.setup({ sources = base_sources(enabled) })
	vim.notify("Copilot in cmp: " .. (enabled and "ENABLED" or "DISABLED"))
end

function M.enable()
	enabled = true
	apply()
end
function M.disable()
	enabled = false
	apply()
end
function M.toggle()
	enabled = not enabled
	apply()
end

return M
