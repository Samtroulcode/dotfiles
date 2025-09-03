# fzfm — picker SFTP multi-racines, multi-sélection, sans errexit/pipefail
fzfm() {
  emulate -L zsh        # remet un environnement zsh propre
  setopt localoptions   # confine les options à la fonction
  # surtout PAS de: set -e / set -u / pipefail

  local userhost="sam@10.100.0.1"

  # Racines à parcourir
  local -a roots=(
    "/home/sam/storage/media"
    "/home/dan/storage/media"
    "/home/bag/storage/media"
  )

  # Vérifs basiques
  for cmd in ssh fzf mpv python; do
    command -v "$cmd" >/dev/null || { echo "$cmd manquant dans PATH" >&2; return 127; }
  done

  # Construit la commande find exécutée DISTANT (pas d'expansion locale des * grâce aux quotes)
  local find_cmd="find"
  local r
  for r in "${roots[@]}"; do
    find_cmd+=" '$(printf "%s" "$r")'"
  done
  find_cmd+=" -type f \( -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.m4v' -o -iname '*.avi' \) -printf '%p\n' 2>/dev/null"

  # Liste -> fzf (multi). Si tu quittes fzf, on retourne proprement sans tuer le shell.
  local selection
  selection="$(
    ssh "$userhost" "$find_cmd" \
      | fzf -m --prompt='🎬 pick (Tab multi) > ' --height=80% --reverse
  )" || return 0

  [[ -z "$selection" ]] && return 0

  # Construit la playlist d'URL SFTP (URL-encode chaque ligne)
  local -a urls=()
  local line enc
  while IFS= read -r line; do
    enc="$(
      python - <<'PY'
import urllib.parse, sys
print(urllib.parse.quote(sys.stdin.read().strip()), end="")
PY
      <<<"$line"
    )"
    urls+=("sftp://$userhost$enc")
  done <<< "$selection"

  echo "mpv (playlist ${#urls[@]} éléments)"
  # Mode "deep probe" optionnel via variable d'environnement (désactivé par défaut)
  if [[ -n "${MPV_DEEP_PROBE:-}" ]]; then
    mpv "${urls[@]}" \
      --demuxer=lavf \
      --demuxer-lavf-probesize=20000000 \
      --demuxer-lavf-analyzeduration=10 \
      --cache=yes --cache-on-disk=yes \
      --demuxer-cache-dir=/tmp/mpvcache \
      --demuxer-max-bytes=512MiB \
      --demuxer-max-back-bytes=128MiB \
      --demuxer-readahead-secs=30 \
      --no-demuxer-cache-wait
  else
    mpv "${urls[@]}" \
      --cache=yes --cache-on-disk=yes \
      --demuxer-cache-dir=/tmp/mpvcache \
      --demuxer-max-bytes=512MiB \
      --demuxer-max-back-bytes=128MiB \
      --demuxer-readahead-secs=30 \
      --no-demuxer-cache-wait
  fi
}


