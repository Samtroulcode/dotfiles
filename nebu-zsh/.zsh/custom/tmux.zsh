# Crée une nouvelle session tmux avec argument possible de nom de session
tm() {
  if [ -z "$1" ]; then
    tmux new
  else
    tmux new -s "$1"
  fi
}

# Attache un tmux avec argument possible de session
tma() {
  if [ -z "$1" ]; then
    tmux attach
  else
    tmux attach -t "$1"
  fi
}

# Kill une session tmux ou le serveur tmux si aucun argument
tmk() {
  if [ -z "$1" ]; then
    tmux kill-server
  else
    tmux kill-session -t "$1"
  fi
}

alias tmls='tmux ls'
