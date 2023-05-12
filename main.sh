#!/bin/bash

echo "Que voulez-vous faire ?"
select i in "Voulez-vous faire une installation ?" "Néttoyer votre machine d'une installation ?"; do
        if [ "$i" = "Voulez-vous faire une installation ?" ]; then
                input=1
                break
        elif [ "$i" = "Néttoyer votre machine d'une installation ?" ]; then
                input=2
                break
        else
                echo "mauvaise reponse"
        fi
done

#
# *** Fonction pour récuperer les données du fichier csv ***
#

#Séparateur 
#Utilisation du -r avec read pour ne pas interpréter les caractères d'échappement (exemple avec l'antislash)
while IFS=";" read -r name surname mail password; do
        echo -e "\n$name - $surname - $password"
        login="${name:0:1}${surname// /}" #On prend 1 lettre à l'index 0 du nom, puis on rajoute le nom sans les espaces pour les nom composés
        echo "$login" #Utilisation du -e pour appliquer l'antislash (plus lisible dans la console)

        if [ $input == 2 ]; then
                sudo userdel -r $login
        else 
                sudo useradd -m "$login"
                variable_sans_fin_de_ligne=$(echo "$password" | sed 's/\0$//')
                echo "$login:$variable_sans_fin_de_ligne" | sudo chpasswd
                chage -d 0 $login # Définir la date d'expiration du mot de passe

                if [ ! -d "/home/$login/a_sauver" ]; then
                        sudo mkdir /home/$login/a_sauver
                fi
        fi      


        

done <"accounts.csv"

#sudo mkdir /home/shared
#sudo chown root /home/shared