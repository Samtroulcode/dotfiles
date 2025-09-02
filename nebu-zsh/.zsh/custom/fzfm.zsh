fzfm() {
  emulate -L zsh
  set -eu -o pipefail

  # Connexion directe (évite les surprises libssh)
  local userhost="sam@10.100.0.1"

  # Racines à parcourir sur le serveur
  local -a roots=(
    "/home/sam/storage/media"
    "/home/dan/storage/media"
    "/home/bag/storage/media"
  )

  # Vérifs de base
  for cmd in ssh fzf mpv python; do
    command -v "$cmd" >/dev/null || { echo "$cmd introuvable dans PATH" >&2; return 127; }
  done

  # Construire la commande 'find' côté serveur (sans expansion locale)
  # On insère chaque racine entre quotes simples pour que le remote bash les voie correctement.
  local remote_roots; remote_roots="$(printf " '%s'" "${roots[@]}")"
  local find_cmd="find${remote_roots} -type f \( -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.m4v' -o -iname '*.avi' \) -printf '%p\n' 2>/dev/null"

  # Liste distante -> fzf multi (séparateurs: newline, pas de NUL)
  local selection
  selection="$(
    ssh "$userhost" "$find_cmd" \
      | fzf -m --prompt='🎬 pick (Tab multi) > ' --height=80% --reverse
  )" || return 1

  [[ -z "$selection" ]] && return 1

  # Construire la playlist d'URLs SFTP (encodage URL par élément)
  local -a urls=()
  while IFS= read -r line; do
    # encodage URL sans newline
    local enc
    enc="$(
      python - <<'PY'
import urllib.parse, sys
print(urllib.parse.quote(sys.stdin.read().strip()), end="")
PY
      <<<"$line"
    )"
    urls+=("sftp://$userhost$enc")
  done <<< "$selection"

  echo "▶️  mpv (playlist ${#urls[@]} éléments)"
  mpv "${urls[@]}" \
    --cache=yes \
    --cache-on-disk=yes \
    --demuxer-cache-dir=/tmp/mpvcache \
    --demuxer-max-bytes=512MiB \
    --demuxer-max-back-bytes=128MiB \
    --demuxer-readahead-secs=30 \
    --no-demuxer-cache-wait
}

