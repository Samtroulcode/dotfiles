#!/bin/bash

echo "===[ PACMAN ]==="
echo "Total      : $(pacman -Qq | wc -l)"
echo "Explicites : $(pacman -Qe | wc -l)"
echo "Dépendances: $(pacman -Qd | wc -l)"
echo "Orphelins  : $(pacman -Qdtq | wc -l)"
echo
echo "===[ AUR ]==="
aur_list=$(pacman -Qqm)
aur_explicit=$(comm -12 <(echo "$aur_list" | sort) <(pacman -Qeq | sort) | wc -l)
aur_dep=$(comm -23 <(echo "$aur_list" | sort) <(pacman -Qeq | sort) | wc -l)
aur_total=$(echo "$aur_list" | wc -l)
aur_orphans=$(pacman -Qmtdq | wc -l)
echo "Total      : $aur_total"
echo "Explicites : $aur_explicit"
echo "Dépendances: $aur_dep"
echo "Orphelins  : $aur_orphans"
echo
total_explicit=$(pacman -Qeq | wc -l)
total_deps=$(pacman -Qdq | wc -l)
total_orphans=$(pacman -Qdtq | wc -l)
echo "===[ TOTAL ]==="
echo "Explicites : $total_explicit"
echo "Dépendances: $total_deps"
echo "Orphelins  : $total_orphans"
total=$(pacman -Qq | wc -l)
echo "TOTAL      : $total"

