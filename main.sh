#!/bin/bash


#
# *** Fonction pour récuperer les données du fichier csv ***
#

#Séparateur 
#Utilisation du -r avec read pour ne pas interpréter les caractères d'échappement (exemple avec l'antislash)
while IFS=";" read -r name surname mail password; do
    echo "$name - $surname"
    login="${name:0:1}${surname// /}" #On prend 1 lettre à l'index 0 du nom, puis on rajoute le nom sans les espaces pour les nom composés
    echo -e "$login\n" #Utilisation du -e pour appliquer l'antislash (plus lisible dans la console)

done <"accounts.csv"