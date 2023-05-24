#!/bin/bash


#*---------------------------------------------------------*
#*                Définition des variables                 *
#*---------------------------------------------------------*
file="accounts.csv"
username="mgrell25"
server_ip="10.30.48.100"
#Ici il faut mettrer l'adresse mail de l'envoyeur avec le @ remplacer par %40 
sender_mail="mael.grellier-neau@isen-ouest.yncrea.fr"
#Là, l'adresse avec l'@
sender_mail_full="mael.grellier-neau%40isen-ouest.yncrea.fr"
#Le mot de passe du compte mail
sender_passwd="68Mgn04N*"
#Les informations du serveur smtp de l'envoyeur
auth_param="smtp.office365.com:587"


#*---------------------------------------------------------*
#*               Configuration du Pare-feu                 *
#*---------------------------------------------------------*
#apt-get install ufw
#ufw active
#Bloque toutes les connexions de type FTP (sur le port 21)
#ufw deny 21 
#Bloque toutes les connexions de type UDP
#ufw deny udp
#Besoin de redemarrer pour appliquer les modifications
#ufw reload 


#*---------------------------------------------------------*
#*     Fonction pour le choix de méthode d'éxécution       *
#*---------------------------------------------------------*
echo "Que voulez-vous faire ?"
select i in "Voulez-vous faire une installation ?" "Néttoyer votre machine d'une installation ? (suppresion de tous les fichiers en lien avec le projet)"; do
        if [ "$i" = "Voulez-vous faire une installation ?" ]; then
                input=1
                break
        elif [ "$i" = "Néttoyer votre machine d'une installation ? (suppresion de tous les fichiers en lien avec le projet)" ]; then
                input=2
                break
        else
                echo "Erreur dans la saisie, veuillez ressayer."
        fi
done


#*---------------------------------------------------------*
#*   Fonction pour la création des différents fichiers     *
#*---------------------------------------------------------*
if [ $input == 1 ]; then
        if [ ! -d "/home/shared" ]; then
                #Création su fichier shared
                mkdir /home/shared
                #Changement de l'appartenance à root
                chown root /home/shared
                chmod o+rx /home/shared
        fi
else 
        if [ -d "/home/shared" ]; then
                rm -r /home/shared
        fi
fi


#*---------------------------------------------------------*
#*   Fonction pour récuperer les données du fichier csv    *
#*---------------------------------------------------------*
#Lecture dans le fichier 
#Utilisation du -r avec read pour ne pas interpréter les caractères d'échappement (exemple avec l'antislash)
#Source : https://forum.ubuntu-fr.org/viewtopic.php?id=245081
while IFS=";" read -r name surname mail password;
do
        #Affichage du prénom, du nom ainsi que le mot de passe. 
        #Utilisation du -e pour appliquer l'antislash (plus lisible dans la console)
        echo -e "\n$name - $surname - $password"

        #Le login de la personne est constitué de la première lettre du prénom puis, du nom sans espace.
        #On prend 1 lettre à l'index 0 du prénom, puis on rajoute le nom sans les espaces pour les nom composés
        login="${name:0:1}${surname// /}" 

        if [ $input == 2 ]; then
                if [ -d "/home/$login" ]; then
                        userdel -r $login
                fi
        else 
                if [ ! -d "/home/$login" ]; then
                        useradd -m "$login"
                        echo -e "${password::-2}\n${password::-2}" | passwd "$login"

                        # Définir la date d'expiration du mot de passe à 0
                        chage -d 0 $login 
                fi


                # Création du fichier a_sauver pour les utilisateurs s'il n'exixte pas
                if [ ! -d "/home/$login/a_sauver" ]; then
                        mkdir /home/$login/a_sauver
                fi


                #Creation du fichier de l'utilisateur dans le fichier shared s'il n'existe pas
                if [ ! -d "/home/shared/$login" ]; then
                        mkdir /home/shared/$login
                fi
                chown $login /home/shared/$login
                chmod o+rx /home/shared/$login
                chmod u-rx /home/shared/$login
                chmod u+w /home/shared/$login


                #*---------------------------------------------------------*
                #*           Envoie des mails aux utilisateurs             *
                #*---------------------------------------------------------*
                ssh -n -i /home/isen/.ssh/id_rsa mgrell25@10.30.48.100 "mail --subject \"$name $surname, votre compte à été créé !\" --exec \"set sendmail=smtp://${sender_mail/@/%40}:$sender_passwd;auth=LOGIN@smtp.office365.com:587\" --append \"From:mael.grellier-neau@isen-ouest.yncrea.fr\" mael.grelneau@gmail.com <<< \"Bonjour, \n bonne nouvelle, votre compte est désormais disponible.\Pour pouvoir vous connectez, il vous suffit de vous munir de votre identifiant ainsi que votre mot de passe :\n Identifiant : $login\n Mot de passe : $password\n A des fin de sécurité, lors de votre 1er connexion, vous devrez changer votre mot de passe.\nCordialement.\""


                #*---------------------------------------------------------*
                #*            Sauvegarde sur le serveur distant            *
                #*---------------------------------------------------------*
                crontab -l | { cat; echo "0 23 * * 1-5 tar -czvf save_$login.tgz /home/$login/a_sauver"; } | crontab -
                crontab -l | { cat; echo "0 23 * * 1-5 scp -i /home/isen/.ssh/id_rsa save_$login.tgz mgrell25@server_ip:/home/saves"; } | crontab -
                crontab -l | { cat; echo "0 23 * * 1-5 rm save_$login.tgz"; } | crontab -
                

                #*---------------------------------------------------------*
                #*           Configuration du serveur Nextcloud            *
                #*---------------------------------------------------------*
               



                
        fi
#https://stackoverflow.com/questions/28927162/why-process-substitution-does-not-always-work-with-while-loop-in-bash
done < <(awk 'NR>1' $file)