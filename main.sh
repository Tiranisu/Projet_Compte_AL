#!/bin/bash

#*---------------------------------------------------------*
#*                Définition des variables                 *
#*---------------------------------------------------------*
file="accounts.csv"
username="mgrell25"
server_ip="10.30.48.100"

#*---------------------------------------------------------*
#*     Fonction pour le choix de méthode d'éxécution       *
#*---------------------------------------------------------*
echo "Que voulez-vous faire ?"
select i in "Voulez-vous faire une installation ?" "Néttoyer votre machine d'une installation ?"; do
        if [ "$i" = "Voulez-vous faire une installation ?" ]; then
                input=1
                break
        elif [ "$i" = "Néttoyer votre machine d'une installation ?" ]; then
                input=2
                break
        else
                echo "Erreur dans la saisie, veuillez ressayer."
        fi
done


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
                userdel -r $login
        else 
                if [ ! -d "/home/$login" ]; then
                        useradd -m "$login"
                        password_clean=$(echo "$password" | sed 's/\n$//'| sed 's/ $//' | sed 's/\r$//')
                        echo -e "$password_clean\n$password_clean" | passwd "$login"
                        chage -d 0 $login # Définir la date d'expiration du mot de passe30
                fi

                # Création du fichier a_sauver pour les utilisateurs s'il n'exixte pas
                if [ ! -d "/home/$login/a_sauver" ]; then
                        mkdir /home/$login/a_sauver
                fi
        fi

done < <(awk 'NR>1' $file)

#sudo mkdir /home/shared
#sudo chown root /home/shared