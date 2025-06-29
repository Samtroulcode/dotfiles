#!/bin/bash

# Vérifie si le service Waybar est actif
if systemctl --user is-active --quiet waybar.service; then
  systemctl --user stop --now waybar.service
else
  systemctl --user start --now waybar.service
fi
