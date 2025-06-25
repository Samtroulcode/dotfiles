#!/bin/bash

url="$1"

# 1. Lancer qutebrowser dans une session dédiée (instance unique)
qutebrowser --target window "$url" &
pid=$!

# 2. Attendre le temps que YouTube "voit" la vidéo (JS, player, etc.)
sleep 12

# 3. Fermer proprement uniquement cette instance
kill "$pid" 2>/dev/null

# 4. Ajouter la vidéo à la playlist de umpv
umpv --enqueue "$url"
