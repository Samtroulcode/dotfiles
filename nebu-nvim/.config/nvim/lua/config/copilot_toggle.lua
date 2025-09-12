local M = {}
local function ensure_cmp_loaded()
	local ok = pcall(require, "cmp")
	if not ok then
		pcall(function()
			require("lazy").load({ plugins = { "nvim-cmp" } })
		end)
	end
end

local function has_copilot(sources)
	for _, s in ipairs(sources or {}) do
		if s.name == "copilot" then
			return true
		end
	end
end

local function without_copilot(sources)
	local out = {}
	for _, s in ipairs(sources or {}) do
		if s.name ~= "copilot" then
			table.insert(out, s)
		end
	end
	return out
end

local function with_copilot(sources)
	if has_copilot(sources) then
		return sources
	end
	local out = vim.deepcopy(sources or {})
	table.insert(out, 1, { name = "copilot" })
	return out
end

local function apply(enable)
	ensure_cmp_loaded()
	local cmp = require("cmp")
	local cfg = cmp.get_config() or {}
	local new_sources = enable and with_copilot(cfg.sources) or without_copilot(cfg.sources)
	cmp.setup({ sources = new_sources })
	vim.g._copilot_cmp_enabled = enable and 1 or 0
	vim.notify("Copilot in cmp: " .. (enable and "enabled" or "disabled"))
end

function M.enable()
	apply(true)
end
function M.disable()
	apply(false)
end
function M.toggle()
	apply(vim.g._copilot_cmp_enabled ~= 1)
end

-- commandes conviviales
vim.api.nvim_create_user_command("CopilotCmpEnable", M.enable, {})
vim.api.nvim_create_user_command("CopilotCmpDisable", M.disable, {})
vim.api.nvim_create_user_command("CopilotCmpToggle", M.toggle, {})

return M
