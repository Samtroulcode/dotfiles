return {
  "andweeb/presence.nvim",
  event = "VeryLazy",
  config = function()
    require("presence").setup({
      neovim_image_text = "Neovim ftw!",
      buttons = false,
      show_time = true,
    })
  end,
}
