# Extra completion bindings after compinit/OMZ.

if (( $+functions[compdef] )); then
  compdef _eza ls 2>/dev/null || true
fi
