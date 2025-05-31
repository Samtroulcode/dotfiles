philosophie KISS (Keep It Simple, Stupid)

Mises à jour système

	- pacman -Syu fréquent (idéalement tous les 2–3 jours, bonne pratique également pour l'installation des paquets)
		-S : indique à pacman que vous souhaitez synchroniser les paquets. Cela signifie que vous allez installer ou mettre à jour des paquets.
		-y : permet de mettre à jour l'index (la db des paquets).
		-u : indique à pacman de mettre à jour tous les paquets installés qui ont des mises à jour disponibles (AUR inclu)

    - Reboot après mise à jour du kernel, systemd ou glibc

    - Lire le feed RSS ou archlinux.org/news pour les breaking changes

Nettoyage régulier

    - pacman -Qdtq → packages orphelins à supprimer (pareil avec yay ou paru pour AUR)
    	-Q : Interroge la base de données des paquets installés.
    	-t : Filtre pour ne montrer que les paquets qui ont été installés comme dépendances.
    	-d : Filtre pour ne montrer que les paquets qui ne sont pas requis par d'autres paquets.
    	-q : Affiche uniquement les noms des paquets, sans autres informations.


    - sudo paccache -r → nettoyer les caches (peut garder -k 2 pour 2 versions)

    - /var/log/journal/ → journal systemd limité avec SystemMaxUse=100M dans journald.conf

	- htop ou btop (optionnel) pour surveillance systeme

Gestion des paquets:
	
	- pacman -Syu <paquet> : THE bonne pratique pour l'installation des paquets

	- pacman -Qe : liste les paquets
		-Q : Indique que vous interrogez la base de données des paquets installés.
    	-e : Filtre pour ne montrer que les paquets qui ont été installés explicitement par l'utilisateur, c'est-à-dire ceux qui ont été installés manuellement et non en tant que dépendances d'autres paquets.


	- pacman -Rns Pour désinstallé un paquet
    	-R : Supprime le paquet spécifié.
    	-n : Supprime les fichiers de configuration associés au paquet.
    	-s : Supprime les dépendances qui ont été installées avec le paquet et qui ne sont plus nécessaires par d'autres paquets.

	- pacman -Qi : Vérifier l’espace utilisé par les paquet (option <paquet> pour 1 paquet, ou vide pour tout listé)
		-Q : pckg installé
		-i : info

	- pacman -Qq : Audit des paquets volumineux

	- pacman -Qqe : Rechercher les paquets KDE installés


Gestion propre des paquets AUR

    - Utiliser makepkg ou un helper comme paru ou yay

    - Vérifier la propreté des PKGBUILD avant installation

    - Nettoyer les dépendances inutiles : yay ou paru -Qtdq

    - pacman -Qm : liste les paquets AUR
		-m : non installé depuis les dépots officiels

Sécurité

    - Pas d’autologin root ni sudo sans mot de passe
		- "grep -E 'NOPASSWD|ALL' /etc/sudoers /etc/sudoers.d/* 2>/dev/null" pour vérifier

    - ufw ou nftables si connexion réseau
		- sudo ufw status pour vérifié le pare feu

	- Audit poussé avec lynis
		- sudo lynis audit system

    - Vérifier les services actifs : systemctl list-unit-files --state=enabled

	- Mettre en place un système de sauvegarde.

Structure des partitions

	- lsblk -f
	    /, /home, /boot bien séparés

    /etc/fstab propre, UUIDs utilisés (cat /etc/fstab)

Conformité configuration système

	- /etc/locale.gen : locales commentées proprement

	- hostnamectl défini

    - timedatectl activé et synchronisé (systemd-timesyncd ok)

    - /etc/mkinitcpio.conf propre, hooks minimaux mais suffisants

    - systemctl status → aucun échec au boot

    - journalctl -p 3 -xb → aucune erreur critique

Les ctl utiles au quotidien

	Commande		Usage

	systemctl		Gérer les services systemd (start, stop, status, enable...)
	journalctl		Lire les logs système
	hostnamectl		Gérer le nom d’hôte
	timedatectl		Configurer le fuseau horaire, synchronisation NTP
	localectl		Configurer la langue et la disposition clavier
	loginctl		Sessions d'utilisateur (Wayland/X11, tty)
	bootctl			Gérer le bootloader systemd-boot (si utilisé)
	resolvectl		Résolution DNS (remplace resolvconf)
	networkctl		Voir les interfaces réseau (si pas NetworkManager)
	udevadm			Gestion matérielle (udev, périphériques)

Alias et scripts pour maintenance systeme:

	- alias installed='pacman -Qe'

	- alias orphaned='pacman -Qtdq' 

	- alias update='sudo pacman -Syu'

	- alias archnews='lynx https://archlinux.org/news/' <=== Flux rss d'arch

Système de sauvegarde du système:

	- Bonne pratique: 3 couches complémentaires (Paquets, dotfiles, fichiers)

	- doit être effectué régulièrement pour évité toute maj qui casse le système et être a jour

		- PAQUETS (hebdo) couche permettant de reconstituer l’environnement logiciel du système.
			- pacman -Qqe > ~/backup/pkglist.txt          # Paquets "explicites"
			- pacman -Qqm > ~/backup/aurlist.txt          # Paquets AUR
	
			- RESTAURATION => 'sudo pacman -Syu --needed - < ~/backup/pkglist.txt' et 'yay -S --needed - < ~/backup/aurlist.txt' (necessite d'avoir yay installé sur le système)

		- DOTFILES (hebdo aussi, suivant mes modifications) 
			- Git bare pour ne pas polluer mon home (git init --bare $HOME/.dotfiles), l'utilisation de git permet:
				de versionner ma config proprement,
				de la restaurer rapidement,
				de synchroniser plusieurs machines.

			- config config --local status.showUntrackedFiles no <=== évite que git me spamme avec les fichiers dans home que je tracke pas

			- alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' (pour pouvoir utilisé 'config' comme si j'utilisé 'git', status, add, etc...)

			- workflow d'utilisation: comme git mais avec config : 
				config status
				config add <dotfile> 
				config add -u  # Pour ajouté les fichiers modifié
				config commit -m "nom de commit" 
				config push

				EVITER LES -a, car rajoute tous les fichiers non ignorés du dépot, risque d'ajouter un fichier indésirable
			
			- RESTAURATION COMPLETE (nouveau systeme par exemple) => 
				1 Cloner le dépôt - git clone --bare git@github.com:sam/dotfiles.git $HOME/.dotfiles 
				2 Activer la commande config - alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
				3 Extraire les fichiers - config checkout
				4 Cacher les non-suivis - config config --local status.showUntrackedFiles no

			- RESTAURATION PARTIELLE =>
				- Revenir a un état précédent (global, les fichiers locaux seront écrasé):
					config log => Trouver le commit voulu
					config checkout <commit_hash>
				- Revenir à un état précédent d’UN fichier :
					config log -- path/to/file
					config checkout <commit> -- path/to/file

			- Bonnes pratiques Git
				Action							Bonne pratique ?		Détail
				Un commit par fichier	 		Too much				Trop verbeux, peu utile
				Un commit par lot cohérent	 	Recommandé				Regrouper par thème : ex. "Mise à jour shell + aliases"
				Push après test					Indispensable			Toujours tester avant push
				Branches de test (optionnel)	Si expérimenté			config checkout -b dev-aliases
				
		- FICHIERS
			- SYSTEME A METTRE EN PLACE

Structure d'un audit :

    1. Mises à jour et état général du système

    2. Nettoyage & paquets orphelins

    3. Paquets AUR et gestion des dépendances

    4. Sécurité (sudo, services, firewall)

    5. Partitions & fstab

    6. Locales, hostname, timezone

    7. mkinitcpio, journalctl, systemd

    8. Fichiers .pacnew, confs à jour
