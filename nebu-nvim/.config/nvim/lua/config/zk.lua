local M = {}
local zk_cmd = require("zk.commands")

-- ==== Actions génériques ====
function M.new_note()
	local title = vim.fn.input("Titre: ")
	if title == nil then
		return
	end
	zk_cmd.get("ZkNew")({ title = title })
end

function M.new_daily()
	-- respecte ton group "daily" -> journal/daily + template daily.md
	zk_cmd.get("ZkNew")({ dir = "journal/daily", group = "daily" })
end

function M.browse()
	zk_cmd.get("ZkNotes")({ sort = { "modified", "desc" } })
end

function M.recents()
	zk_cmd.get("ZkNotes")({
		createdAfter = "last two weeks",
		sort = { "created", "desc" },
		select = { "title", "path", "modified" },
	})
end

function M.tags()
	zk_cmd.get("ZkTags")({})
end

function M.backlinks()
	zk_cmd.get("ZkBacklinks")({})
end

function M.links()
	zk_cmd.get("ZkLinks")({})
end

function M.grep()
	local q = vim.fn.input("Rechercher (notes): ")
	if q and q ~= "" then
		zk_cmd.get("ZkNotes")({ match = q, sort = { "modified", "desc" } })
	end
end

-- ==== Insertion de lien ====
function M.insert_link_cursor()
	zk_cmd.get("ZkInsertLink")({})
end

function M.insert_link_visual()
	zk_cmd.get("ZkInsertLink")({ content = "selection" })
end

return M
