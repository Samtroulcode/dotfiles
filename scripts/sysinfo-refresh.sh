#!/usr/bin/env bash
# ~/.local/bin/sysinfo-refresh
{
  echo "###  Infos système (auto)  ###"
  echo "Hostname: $(hostname)"
  echo "Kernel: $(uname -r)"
  echo "CPU: $(lscpu | grep 'Model name' | sed 's/^[^:]*: //')"
  echo "GPU: $(lspci | grep -E 'VGA|3D' | cut -d':' -f3-)"
  echo "RAM: $(free -h --si | awk '/Mem:/ {print $2}')"
  echo "Hyprland: $(hyprctl version | head -1)"
  echo "Shell: $SHELL"
  echo "-----------------------------"
  env | grep -E 'LANG|TERM|EDITOR|VISUAL'
} >/tmp/sysinfo.txt
