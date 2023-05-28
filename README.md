# Projet_Compte_AL

L’objectif de ce projet est de mettre à profit les compétences que vous avez acquises durant les cours-TP successifs dans un unique projet. Vous aurez aussi à utiliser des outils que vous n’avez pas utilisé jusqu’à présent de manière autonome. Dans ce projet, vous devrez créer un script de déploiement de comptes pour une liste d’utilisateurs.trices

## Etapes du projet :
- [X] Base : (6 points)
    - [x] Création d’un compte sur une machine locale, avec un home, un login déterminé, un mot de passe déterminé et à changer
    - [X] Envoi de mail de connexion avec explications (serveur smtp)
- [X] Sauvegarde : (4 points)
    - [X] Système de sauvegarde automatique d’un dossier
    - [X] Zippé
    - [X] Envoi au serveur
    - [X] Capacité à récupérer le fichier zippé et à le rétablir
- [X] Eclipse : (1 points)
- [X] Pare-feux : (1 point)
- [X] Nextcloud : (5 points)
- [X] Monitoring : (3 points)


Pour que le programme fonctionne, il faut impérativement avoir configuré son accès ssh grace à son id-rsa. Sinon il vous demandera d'entrer le mot de passe au moment de la connexion


## Execution du programme
Vous devez impérativement exécuter le script en super-administrateur !
Pour le lancer vous devez faire :
```bash
sudo su
./main.sh <serveur_de_mail> <login_mail> <mot_de_passe_mail>
```
serveur_de_mail correspond au paramètre du serveur de mail utilisé (exemple avec outlook : smtp.office365.com:587)


## Serveur Nextcloud
Pour avoir accès au Nextcloud il faut lancer le tunnel ssh grâce au script tunnel_nextcloud dans le répertoire home.
```bash
/home/tunnel_nextcloud
```

## Serveur Nextcloud
Pour avoir accès à l'affichage du monitoring, il faut lancer le script du tunnel ssh du monitoring sur le port 19999 du serveur.
```bash
/home/tunnel_monitoring
```