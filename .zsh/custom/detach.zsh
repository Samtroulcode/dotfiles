# détache un process du shell
detach() {
  nohup "$@" > /dev/null 2>&1 < /dev/null &
  disown
}
