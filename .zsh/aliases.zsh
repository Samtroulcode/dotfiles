# ~/.zsh/aliases.zsh
# Liste des alias

# Aliases généraux
alias ..='cd ..'
alias ...='cd ../..'
alias vi="nvim"
alias please='sudo'
alias fucking='sudo'
alias indent='shfmt -w -i 2'

# Aliases de maintenance
alias update='sudo pacman -Syu'
alias update-full='sudo pacman -Syyu'
alias orphanclean='sudo pacman -Rns $(pacman -Qtdq) --ask 1'
alias mirror-refresh='sudo reflector --country "France,Germany" --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
alias installed='pacman -Qe'
alias installedAur='pacman -Qm'
alias orphaned='pacman -Qtdq'
alias orphanedAur='yay -Qtdq'
alias clean-cache='sudo paccache -rk2 && sudo paccache -ruk0'
alias path='echo -e ${PATH//:/\\n}'
alias pacfind='pacman -Q | grep -i'
alias pacdiff='sudo pacdiff'
alias pacrecent='grep "\[ALPM\] installed" /var/log/pacman.log | tail -n 20'

# Aliases de sauvegarde
alias savepkg='pacman -Qqe > ~/backup/pkglist.txt'
alias saveaur='pacman -Qqm > ~/backup/aurlist.txt'

# Aliases réseau
alias ports='ss -tulwn'
alias ipinfo='ip -c a'
alias pingg='ping -c 3 1.1.1.1'
alias pingdns='ping -c 3 archlinux.org'
alias archnews='lynx https://archlinux.org/news/' 

# Aliases de scripts
alias backup='bash ~/scripts/backup-home.sh'
alias clean='bash ~/scripts/arch-clean.sh | tee "$HOME/.cache/arch-clean-$(date +%F_%H-%M).log"'
alias pacstats='bash ~/scripts/pacstats.sh'
alias audit='bash ~/scripts/sys-audit.sh'

# Aliases de sauvegarde de mes dot files
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
