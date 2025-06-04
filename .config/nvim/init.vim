" Activer les couleurs de base
syntax on

" Activer le mode de coloration avancé si disponible
set termguicolors
set background=dark

" Utiliser un thème simple (par exemple 'elflord' ou 'desert')
colorscheme desert

" Utiliser le fond du terminal (donc transparent si ton terminal l'est)
highlight Normal ctermbg=none guibg=none
highlight NormalNC ctermbg=none guibg=none

" Supprimer les lignes blanches autour du texte
set number
set relativenumber
set cursorline

