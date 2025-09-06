return {
	-- 1) Copilot LSP (backend)
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			-- IMPORTANT: on veut tout via cmp, donc on coupe le ghost-text & le panel
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				help = false,
				gitcommit = false,
				gitrebase = false,
				["."] = false,
			},
		},
	},

	-- 2) Source cmp pour Copilot
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	-- 3) Copilot Chat
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		build = "make tiktoken", -- optionnel, pour le comptage de tokens
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatClose",
			"CopilotChatToggle",
			"CopilotChatPrompts",
			"CopilotChatModels",
			"CopilotChatReset",
			"CopilotChatSave",
			"CopilotChatLoad",
		},
		opts = {
			window = { layout = "vertical", width = 0.45, title = "   Copilot Chat " },
			auto_insert_mode = true,
			-- Tu peux fixer un modèle si tu veux:
			-- model = "gpt-4o",
		},
	},
}
