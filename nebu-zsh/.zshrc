# ~/.zshrc
# On garde ce fichier réduit au minimum, et on charge les autres fichiers de configuration depuis le dossier ~/.zsh/init

ZSH_INIT_DIR="$HOME/.zsh/init"

if [[ -d "$ZSH_INIT_DIR" ]]; then
  for f in "$ZSH_INIT_DIR"/*.zsh(N); do
    source "$f"
  done
fi
