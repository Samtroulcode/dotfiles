return {
	{
		"ixru/nvim-markdown",
		ft = { "markdown" }, -- ne se charge que pour les .md
		config = function()
			-- options basiques (issues du README)
			vim.g.vim_markdown_folding_disabled = 1 -- pas de folding auto
			vim.g.vim_markdown_conceal = 0 -- garde les ** et # visibles
			vim.g.vim_markdown_new_list_item_indent = 2
			-- lua/snippets/markdown.lua
			local ls = require("luasnip")
			local s = ls.snippet
			local i = ls.insert_node
			local fmt = require("luasnip.extras.fmt").fmt

			ls.add_snippets("markdown", {
				s(
					"fence",
					fmt(
						[[```{}
{}
```]],
						{ i(1, "lang"), i(0) }
					)
				),
			})
		end,
	},
}
