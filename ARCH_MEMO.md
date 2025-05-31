philosophie KISS (Keep It Simple, Stupid)

Mises à jour système

	- pacman -Syu fréquent (idéalement tous les 2–3 jours, bonne pratique également pour l'installation des paquets) : ALIAS "update"
		-S : indique à pacman que vous souhaitez synchroniser les paquets. Cela signifie que vous allez installer ou mettre à jour des paquets.
		-y : permet de mettre à jour l'index (la db des paquets).
		-u : indique à pacman de mettre à jour tous les paquets installés qui ont des mises à jour disponibles (AUR inclu)

    - Reboot après mise à jour du kernel, systemd ou glibc

    - Lire le feed RSS ou archlinux.org/news pour les breaking changes : ALIAS "archnews"

	- VOIR SCRIPT CLEAN (dans nettoyage régulier, emplacement: /script/arch-clean.sh versionné avec git bare)

Nettoyage régulier

    - pacman -Qdtq → packages orphelins à supprimer (pareil avec yay ou paru pour AUR)
    	-Q : Interroge la base de données des paquets installés.
    	-t : Filtre pour ne montrer que les paquets qui ont été installés comme dépendances.
    	-d : Filtre pour ne montrer que les paquets qui ne sont pas requis par d'autres paquets.
    	-q : Affiche uniquement les noms des paquets, sans autres informations.

	- pacman -Rns $(pacman -Qtdq) --ask 1 : ALIAS "orphanclean"

	- sudo paccache -rk2 && sudo paccache -ruk0
		-rk2 : tu gardes 2 versions installées (rollback possible)
		-ruk0 : tu vires les paquets orphelins (non installés)

    - /var/log/journal/ → journal systemd limité avec SystemMaxUse=100M dans journald.conf

	- journalctl -p 3 -xb -n 10 : pour voir les erreurs critiques

	- script de clean : ALIAS "clean"
		- sudo pacman -Syu
		- pacman -Rns $(pacman -Qtdq)
		- sudo paccache -rk2 && sudo paccache -ruk0 (pareil pour yay)
		- sudo journalctl --vacuum-time=7d
		- journalctl -p 3 -xb -n 10

	- htop ou btop (optionnel) pour surveillance systeme

Gestion des paquets:
	
	- pacman -Syu <paquet> : THE bonne pratique pour l'installation des paquets

	- pacman -Qe : liste les paquets : ALIAS "installed"
		-Q : Indique que vous interrogez la base de données des paquets installés.
    	-e : Filtre pour ne montrer que les paquets qui ont été installés explicitement par l'utilisateur, c'est-à-dire ceux qui ont été installés manuellement et non en tant que dépendances d'autres paquets.

	- pacman -Qm : Liste les paquets AUR : ALIAS "installedAur"

	- pacman -Rns Pour désinstallé un paquet
    	-R : Supprime le paquet spécifié.
    	-n : Supprime les fichiers de configuration associés au paquet.
    	-s : Supprime les dépendances qui ont été installées avec le paquet et qui ne sont plus nécessaires par d'autres paquets.

	- pacman -Qi : Vérifier l’espace utilisé par les paquet (option <paquet> pour 1 paquet, ou vide pour tout listé)
		-Q : pckg installé
		-i : info

	- pacman -Qq : Audit des paquets volumineux

	- pacman -Qqe : Rechercher les paquets KDE installés

	- VOIR SCRIPT CLEAN (dans nettoyage régulier, emplacement: /script/arch-clean.sh versionné avec git bare)

Gestion propre des paquets AUR

    - Utiliser makepkg ou un helper comme paru ou yay

    - Vérifier la propreté des PKGBUILD avant installation

    - Nettoyer les dépendances inutiles : yay ou paru -Qtdq

    - pacman -Qm : liste les paquets AUR
		-m : non installé depuis les dépots officiels

	- VOIR SCRIPT CLEAN (dans nettoyage régulier, emplacement: /script/arch-clean.sh versionné avec git bare)

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
	    /, /home, /boot, /backup bien séparés

    /etc/fstab propre, UUIDs utilisés (bat/cat /etc/fstab)

Conformité configuration système

	- /etc/locale.gen : locales commentées proprement

	- hostnamectl défini

    - timedatectl activé et synchronisé (systemd-timesyncd ok)

    - /etc/mkinitcpio.conf propre, hooks minimaux mais suffisants

    - systemctl status : échec au boot

    - journalctl -p 3 -xb : erreur critique

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

Alias et scripts pour maintenance systeme (NON TENU A JOUR):

	- alias installed='pacman -Qe'

	- alias orphaned='pacman -Qtdq' 

	- alias update='sudo pacman -Syu'

	- alias archnews='lynx https://archlinux.org/news/' <=== Flux rss d'arch

Système de sauvegarde du système:

	- Bonne pratique: 3 couches complémentaires (Paquets, dotfiles, fichiers)

	- doit être effectué régulièrement pour évité toute maj qui casse le système et être a jour

		- PAQUETS => Listes via CMD => couche permettant de reconstituer l’environnement logiciel du système.
			- pacman -Qqe > ~/backup/pkglist.txt          # Paquets "explicites" ALIAS savepkg
			- pacman -Qqm > ~/backup/aurlist.txt          # Paquets AUR	ALIAS saveaur
	
			- RESTAURATION => 'sudo pacman -Syu --needed - < ~/backup/pkglist.txt' et 'yay -S --needed - < ~/backup/aurlist.txt' (necessite d'avoir yay installé sur le système)

		- DOTFILES => Git bare => couche permettant de sauvegardé la configuration utilisateur (dotfiles)
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


				SUFFIX COMMIT
				feat	Feature (fonctionnalité)	feat: ajout prompt zsh moderne	Ajout d’un nouveau fichier, script, alias…
				fix	Correction	fix: corrige erreur .zshrc PATH	Corrige un bug ou comportement non voulu
				refactor	Refactorisation (sans impact)	refactor: simplifie alias pacman	Réécriture sans changement de fonctionnalité
				chore	Maintenance / divers	chore: ajout gitconfig, pkglist	Ajout mineur ou maintenance (non fonctionnel)
				docs	Documentation	docs: mise à jour ARCH_MANIFEST.md	Notes, commentaires, fichiers Markdown, etc.
				perf	Optimisation	perf: accélère prompt zsh	Amélioration des performances (rare en dotfiles)
				style	Mise en forme	style: indentation .zshrc	Style de code, indentation, formatage
				test	Ajout de test(s)	test: ajout test script audit	Scripts de test si tu en fais
				ci	Intégration continue	ci: exclude temp files	Si tu as un pipeline (rare en dotfiles)
				revert	Revert (annule un commit)	revert: suppression alias dangereux	Tu annules une erreur
				
		- FICHIERS => rsync => couche pour la sauvegarde des données utilisateurs (images, documents, etc) et la restauration de ceux ci
			- Sauvegarde automatiquement dans /home/sam vers /backup, sur partition dédiée.

			- rsync en mode archive avec suppression (--delete) pour garder la destination identique à la source.
			
			- SAUVEGARDE :
				- rsync -avh --delete <rep a sauvegarder> /backup/<destination> exemple: rsync -avh --delete /home/sam/ /backup/home-sam/ : ALIAS "backup"
					-a : archive mode : conserve les permissions, liens, dates, etc.
					-v : verbose : affiche les fichiers copiés
					-h : human readable : pour tailles lisibles (5.3M etc.)
					--delete : supprime dans /backup les fichiers absents de la source (~/)
					/backup/home-sam/ : destination, bien séparée pour faciliter la restauration
					/ : note le / à la fin : cela copie le contenu de /, pas le dossier lui-même

			- RESTAURATION PARTIELLE => 
				- cp /backup/home-sam/Documents/rapport.txt ~/Documents

			- RESTAURATION COMPLETE =>
				- rsync -a /backup/home-sam/ /mnt/home/sam/

			- Emplacement suivi :
				Source : /home/sam/ => /backup/home-sam/

			- Bonnes pratiques : 
				- bon réflexe post-pacman -Syu	pour éviter une perte due à une MAJ bancale
				- snapshot avant une modif système si installation de paquets expérimentaux ou pacman -Rns risqués

Structure d'un audit :

    1. Mises à jour et état général du système

    2. Nettoyage & paquets orphelins

    3. Paquets AUR et gestion des dépendances

    4. Sécurité (sudo, services, firewall)

    5. Partitions & fstab

    6. Locales, hostname, timezone

    7. mkinitcpio, journalctl, systemd

    8. Fichiers .pacnew, confs à jour

Amélioration potentiels:

	- Aliasé cmd récurentes (EN PARTI)
	- amélioration du script clean (FAIT)
	- versionning logs clean (FAIT)
	- Trouver système de sauvegarde pkg versionné (FAIT)
	- git bare (FAIT)
	- rsync (FAIT)
	- Firejail
	- earlyoom
	- cron des sauvegardes
