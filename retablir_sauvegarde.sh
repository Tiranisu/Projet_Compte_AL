#!/bin/bash

#Récupère le fichier de sauvegarde sur le serveur distant compréssé
scp -i /home/isen/.ssh/id_rsa mgrell25@10.30.48.100:/home/saves/$1


#Décompresse le fichier de sauvegarde
tar -xzvf save_$1.tgz

#Déplacer le fichier de sauvegarde a la place du fichier a_sauver actuel
