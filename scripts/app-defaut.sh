echo "Explorateur de fichiers : $(xdg-mime query default inode/directory)"
echo "Navigateur HTTP : $(xdg-mime query default x-scheme-handler/http)"
echo "Navigateur HTTPS : $(xdg-mime query default x-scheme-handler/https)"
echo "Lecteur d'images : $(xdg-mime query default image/png)"
echo "Lecteur vidéo : $(xdg-mime query default video/mp4)"

