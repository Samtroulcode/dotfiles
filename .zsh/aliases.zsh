# ~/.zsh/aliases.zsh
# Liste des alias

# Aliases généraux
alias ..='cd ..'
alias ...='cd ../..'
alias vi="nvim"
alias please='sudo'
alias fucking='sudo'
alias indent='shfmt -w -i 2'
alias dufs='/usr/bin/duf --hide special'
alias reload='clear && source ~/.zshrc'

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

alias archnews="qutebrowser 'https://archlinux.org/news/'"
alias protonmail="qutebrowser 'https://mail.proton.me'"

alias dnscheck='resolvectl status | grep Current'
alias unlockdns='sudo chattr -i /etc/resolv.conf'
alias lockdns='sudo chattr +i /etc/resolv.conf'
alias editdns='unlockdns && sudo nvim /etc/resolv.conf && lockdns'

alias up0x0='f() { curl -s -F "file=@$1" -F "expires=43200" https://0x0.st; }; f'

alias wgstatus='sudo wg show'

# Télécharger une playlist YouTube entière en MP3 avec covers
alias ytmp3pl='yt-dlp -x --audio-format mp3 --embed-thumbnail --add-metadata -o "~/Storage/Music/Albums/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"'
# Télécharger une vidéo YouTube unique en MP3
alias ytmp3='yt-dlp -x --audio-format mp3 --embed-thumbnail --add-metadata -o "~/Storage/Music/Tracks/%(title)s.%(ext)s"'
# Mettre à jour yt-dlp
alias ytdlp-update='yt-dlp -U'

alias ncmpcpp='ncmpcpp -b ~/.config/ncmpcpp/bindings'

# Aliases de scripts
alias backup='~/scripts/backup-home.sh'
alias clean='~/scripts/arch-clean.sh | tee "$HOME/.cache/arch-clean-$(date +%F_%H-%M).log"'
alias pacstats='~/scripts/pacstats.sh'
alias audit='~/scripts/sys-audit.sh'
alias appdef='~/scripts/app-defaut.sh'
alias ipv6-off='~/scripts/toggle-ipv6.sh off'
alias ipv6-on='~/scripts/toggle-ipv6.sh on'
alias audit-net='~/scripts/audit-network.sh'
alias change-wall='~/.config/wallust/set_wall.sh'

# Aliases de sauvegarde de mes dot files
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias config-clean-deleted='config ls-files --deleted -z | xargs -0 -I{} git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME rm --cached "{}'

# Aliases de sync
alias mount_backup='sudo mount /dev/sdd1 /mnt/external_backup && echo "Disque externe monté !"'
alias umount_backup='sudo umount /mnt/external_backup && echo "Disque externe démonté."'
alias backup_home='sudo ~/scripts/backup_home_external.sh'

# Aliases de montage: 
alias media-mount='sshfs sam@10.100.0.1:/home/sam/storage/media ~/Videos/Sam-media -o IdentityFile=~/.ssh/id_ed25519,StrictHostKeyChecking=no'
alias media-umount='fusermount3 -u ~/Videos/Sam-media'

alias server-mount='sshfs sam@10.100.0.1:/home/sam ~/Documents/Sam -o IdentityFile=~/.ssh/id_ed25519,StrictHostKeyChecking=no'
alias server-umount='fusermount3 -u ~/Documents/Sam'

# Regen du grub
alias grubgen : 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
