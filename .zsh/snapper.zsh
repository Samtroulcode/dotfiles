# Voir la liste des snapshots
alias snapls='sudo snapper -c root list'

# Voir les changements entre deux snapshots
alias snapdiff='sudo snapper -c root status'

# Voir les fichiers modifiés entre deux snapshots (avec pager)
alias snapdiffp='sudo snapper -c root status | less'

# Comparer le snapshot précédent avec l'actuel (id auto)
alias snaplast='sudo snapper -c root status $(( $(snapper -c root list | tail -n 1 | awk "{print \$1}") - 1))..$(snapper -c root list | tail -n 1 | awk "{print \$1}")'

# Voir les fichiers d’un snapshot spécifique
alias snapfiles='sudo snapper -c root list --columns=number,date,description | less'

# Créer un snapshot manuel
alias snapmake='sudo snapper -c root create --description'

# Supprimer un snapshot
alias snaprm='sudo snapper -c root delete'

# Nettoyer les snapshots (selon politique configurée)
alias snapclean='sudo snapper -c root cleanup number'

# Rollback système complet (⚠️ redémarrage nécessaire)
alias snaproll='echo "⚠️ Ceci va restaurer le système. Continue ? (Ctrl+C pour annuler)" && read && sudo snapper -c root rollback && echo "Redémarrage..." && reboot'

# Restaurer un fichier depuis un snapshot (interactive)
alias snaprestore='f() { sudo cp /.snapshots/$1/snapshot/$2 $2 ; }; f'
# usage : snaprestore <ID> <chemin/vers/fichier>

# Naviguer dans un snapshot
alias snapcd='cd /.snapshots'

# Affiche les 5 derniers snapshots
alias snaplast5='sudo snapper -c root list | tail -n 5'

# Créer un snapshot + comparer immédiatement
alias snapquick='sudo snapper -c root create --description "Quick snapshot" && snaplast'

# Lister fichiers modifiés dans le dernier snapshot
alias snaplastfiles='snapper -c root status $(( $(snapper -c root list | tail -n 1 | awk "{print \$1}") - 1))..$(snapper -c root list | tail -n 1 | awk "{print \$1}") | cut -c 6-'

