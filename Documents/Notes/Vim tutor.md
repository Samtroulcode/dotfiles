* Base de l'edition *

se deplacer

h j k l

**suppression**

x - supprime le caractere highlight
d - est un operateur d'effacement

***operateur d'effacement***

une commande d'effacement se compose de l'operateur d et d'un mouvement :

d mouvement

liste de mouvements:

w - jusqu'au début du prochain mot, en EXCLUANT son premier caractère.
e - jusqu'à la fin du mot courant, en EXCLUANT son dernier caractère.
$ - jusqu'à la fin de la ligne, en INCLUANT son dernier caractère.

exemple : "de" efface depuis le curseur jusqu'a la fin du mot, alors que "dw" efface a partir du curseur jusqu'au debut du prochain mot.

***quantificateur avec mouvement***

taper un nombre x avant un mouvement le repete x fois

par exemple 2w permet de se deplacer de 2 mot vers l'avant et 3e deplace le curseur a la fin du troisieme mot vers l'avant

0 permet de revenir au debut de la ligne.

ceci est un playground pour tester les deplacement aussi-avec-des-tirets.

on peux donc utiliser un quantificateur dans une commande de suppression, par exemple :

d2w efface 2 mots a partir du curseur.

pour supprimer une ligne complete, on fera dd.

***annulation***

u - annule la derniere commande
U - remet la ligne dans son etat intial
CTRL-R - annule l'annulation

**RESUME**

1. Pour effacer du curseur jusqu'au mot suivant tapez :         dw

2. Pour effacer du curseur jusqu'à la fin d'une ligne tapez :   d$

3. Pour effacer toute une ligne tapez :                         dd

4. Pour répéter un déplacement ajoutez un quantificateur :      2w

5. Le format d'une commande de changement est :

       opérateur   [nombre]   déplacement

     Où :
       opérateur   - est ce qu'il faut faire, comme  d  pour effacer.
       [nombre]    - un quantificateur optionnel pour répéter le déplacement.
       déplacement - déplace le long du texte à opérer, tel que  w  (mot),
                     $ (jusqu'à la fin de ligne), etc.

6. Pour se déplacer au début de ligne, utilisez un zéro :  0

5. Pour annuler des actions précédentes, tapez :            u (u minuscule)
     Pour annuler tous les changements sur une ligne tapez :  U (U majuscule)
     Pour annuler l'annulation tapez :                        CTRL-R
