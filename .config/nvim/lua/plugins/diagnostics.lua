return {
  "neovim/nvim-lspconfig", -- spec LazyVim déjà installé
  opts = {
    -- tous les réglages supportés par vim.diagnostic.config()
    diagnostics = {
      virtual_text = false, -- pas de texte inline
      underline = true, -- gardons le soulignement
      signs = true, -- gardons les pictos dans la colonne
      update_in_insert = false, -- évite le clignotement en mode Insert
      severity_sort = true, -- tri: erreurs > warnings > infos
    },
  },
}
