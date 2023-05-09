#!/bin/bash


#
# *** Fonction pour récuperer les données du fichier csv ***
#

#Séparateur 
#Utilisation du -r avec read pour ne pas interpréter les caractères d'échappement (exemple avec l'antislash)
while IFS=";" read -r name surname mail password; do
    echo -e "\n$name - $surname - $password"
    login="${name:0:1}${surname// /}" #On prend 1 lettre à l'index 0 du nom, puis on rajoute le nom sans les espaces pour les nom composés
    echo "$login" #Utilisation du -e pour appliquer l'antislash (plus lisible dans la console)

    sudo useradd -m "$login" -p"\"$password\""
    #sudo userdel -r $login
    
    if [ ! -d "/home/$login/a_sauver" ]; then
        sudo mkdir /home/$login/a_sauver
    fi


    sudo mkdir /home/shared
    sudo chown root /home/shared
done <"accounts.csv"