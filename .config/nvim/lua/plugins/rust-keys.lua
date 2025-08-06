return {
  "folke/which-key.nvim",
  -- on dit à LazyVim qu’on veut juste étendre le tableau `spec`
  opts_extend = { "spec" },

  opts = {
    spec = {
      {
        -- on veut ces mappings en mode normal & visuel
        mode = { "n", "v" },

        -- ① on déclare le **groupe** Rust
        { "<leader>r", group = "cargo/crates", icon = { icon = "🦀 ", color = "orange" } },

        -- ② on déclare les sous-commandes Cargo
        { "<leader>rB", "<cmd>CargoBuild<cr>", desc = "Build" },
        { "<leader>rR", "<cmd>CargoRun<cr>", desc = "Run" },
        { "<leader>rt", "<cmd>CargoTest<cr>", desc = "Test" },
        { "<leader>rc", "<cmd>CargoCheck<cr>", desc = "Check" },
        { "<leader>rl", "<cmd>CargoClippy<cr>", desc = "Clippy" },
        { "<leader>rf", "<cmd>CargoFmt<cr>", desc = "Format" },
        { "<leader>rx", "<cmd>CargoFix<cr>", desc = "Fix" },
        { "<leader>rd", "<cmd>CargoDoc<cr>", desc = "Docs" },
        { "<leader>ru", "<cmd>CargoUpdate<cr>", desc = "Update" },
        { "<leader>ra", "<cmd>CargoAdd<cr>", desc = "Add Crate" },
        { "<leader>rr", "<cmd>CargoRemove<cr>", desc = "Remove Crate" },

        -- ③ les actions crates.nvim (dans Cargo.toml)
        {
          "<leader>rv",
          function()
            require("crates").show_versions_popup()
          end,
          desc = "Versions",
        },
        {
          "<leader>rp",
          function()
            require("crates").show_features_popup()
          end,
          desc = "Features",
        },
        {
          "<leader>rd",
          function()
            require("crates").open_documentation()
          end,
          desc = "Docs",
        },
        {
          "<leader>rU",
          function()
            require("crates").upgrade_crate()
          end,
          desc = "Upgrade",
        },
        {
          "<leader>rA",
          function()
            require("crates").upgrade_all_crates()
          end,
          desc = "Upgrade All",
        },
      },
    },
  },
}
