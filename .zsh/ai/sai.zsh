# IA sam-arch
# Dossier de session : ~/.config/aichat/sessions/sam_sys.json
sai() {
  ~/scripts/sysinfo-refresh.sh               # met à jour /tmp/sysinfo.txt

  # Fichiers communs (infos système)
  local files=( -f /tmp/sysinfo.txt )

  # Si l’entrée provient d’un pipe, AIChat lira STDIN tout seul.
  # Rien à ajouter : pas de -f /dev/stdin, pas de tmpfile.

  aichat -m ollama:nebulix:latest -s nebulix --save-session "${files[@]}" "$@"
}
