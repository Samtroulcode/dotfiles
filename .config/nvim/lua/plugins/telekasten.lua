return {
  "renerocksai/telekasten.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local home = vim.fn.expand("~/Documents/Notes")
    require("telekasten").setup({
      home = home,
      take_over_my_home = false,
      auto_set_filetype = false,
      dailies = home .. "/journal",
      templates = home .. "/templates",
    })

    vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>", { desc = "New note" })
    vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>", { desc = "Today’s journal" })
    vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>", { desc = "Find notes" })
    vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>", { desc = "Grep notes" })
  end,
}
