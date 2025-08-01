return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float", -- "horizontal" | "vertical" | "float" | "tab"
      close_on_exit = true,
      shell = vim.o.shell,
    })

    -- Exemple de raccourci custom (à adapter si tu veux)
    vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Terminal flottant" })
  end,
}
