return {
  -- Client DAP de base
  { "mfussenegger/nvim-dap" },

  -- Interface visuelle (facultatif mais pratique)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = true, -- = require("dapui").setup()
  },
}
