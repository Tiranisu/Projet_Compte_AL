#!/bin/bash

username="mgrell25"
server_ip="10.30.48.100"
rsa_key="/home/isen/.ssh/id_rsa"


#Récupère le fichier de sauvegarde sur le serveur distant compréssé
save_path="/home/saves/$1.tgz"
scp -i $rsa_key $username@$server_ip:$save_path



#Décompresse le fichier de sauvegarde
tar -xzvf save_$1.tgz

#Déplacer le fichier de sauvegarde a la place du fichier a_sauver actuel
rm /home/$1/a_sauver
mv home /home/
rm -r home
rm save_$1.tgz
