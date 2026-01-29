#!/bin/bash

SINK="$(pactl get-default-sink)"

if [[ "$SINK" == *Razer_BlackShark* ]]; then
  echo '{"text":"","class":"audio-headset","tooltip":"Casque actif"}'
else
  echo '{"text":"","class":"audio-speaker","tooltip":"Haut-parleurs actifs"}'
fi
