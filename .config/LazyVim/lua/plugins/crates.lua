-- plugins/crates.lua
return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  config = true,
}
