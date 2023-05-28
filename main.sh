#!/bin/bash


#*---------------------------------------------------------*
#*                Définition des variables                 *
#*---------------------------------------------------------*
input_file="accounts.csv"
username="mgrell25"
server_ip="10.30.48.100"
rsa_key="/home/isen/.ssh/id_rsa"
#Ici il faut mettrer l'adresse mail de l'envoyeur avec le @ remplacer par %40 
sender_mail="mael.grellier-neau@isen-ouest.yncrea.fr"
#Là, l'adresse avec l'@
sender_mail_full="mael.grellier-neau%40isen-ouest.yncrea.fr"
#Le mot de passe du compte mail
sender_passwd="68Mgn04N*"
#Les informations du serveur smtp de l'envoyeur
auth_param="smtp.office365.com:587"
 


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
#Si le choix définit par l'utilisateur est de faire une installation alors entrer dans le if
if [ $input == 1 ]; then
        if [ ! -d "/home/shared" ]; then
                #Création su fichier shared
                mkdir /home/shared
                #Changement de l'appartenance à root
                chown root /home/shared
                chmod o+rx /home/shared
        fi


        #*---------------------------------------------------------*
        #*            Sauvegarde sur le serveur distant            *
        #*---------------------------------------------------------*
        #Démarrage de cron pour la routine de sauvegarde tous les jours sauf le WE à 23h 
        service cron start

        #Définition de l'emplacement et du nom de l'archive de sauvegarde sur le serveur distant
        save_path="/home/saves/save_$1.tgz"

        #Création du fichier de restauration
        touch /home/retablir_sauvegarde.sh
        echo "#!/bin/bash" > /home/retablir_sauvegarde.sh

        #Récupère le fichier de sauvegarde sur le serveur distant compréssé
        echo "scp -i $rsa_key $username@$server_ip:$save_path" > /home/retablir_sauvegarde.sh

        #Décompresse le fichier de sauvegarde
        echo "tar -xzvf save_$1.tgz" > /home/retablir_sauvegarde.sh

        #Suppression de l'archive
        echo "rm -r save_$1.tgz" > /home/retablir_sauvegarde.sh

        #Suppression du dossier a_sauver de l'utilisateur
        echo "rm -r /home/$1/a_sauver" > /home/retablir_sauvegarde.sh
        
        #Copie du dossier a_sauver contenu dans l'archive dans le dossier de l'utilisateur 
        echo "mv home/$1/a_sauver /home/$1" > /home/retablir_sauvegarde.sh
        
        #Suppression dde l'archive
        echo "rm -r home" > /home/retablir_sauvegarde.sh



        #*---------------------------------------------------------*
        #*               Configuration du Pare-feu                 *
        #*---------------------------------------------------------*
        #Installation de Uncomplicated Firewall (ufw)
        # apt install ufw -y
        
        #Activation du pare-feu
        # ufw enable
        
        #Bloque toutes les connexions de type FTP
        #ufw deny ftp 
        
        #Bloque toutes les connexions de type UDP
        #ufw deny proto udp from any to any
        
        #Redemarrer pour appliquer les modifications
        #ufw reload


        #*---------------------------------------------------------*
        #*                Installation de Eclipse                  *
        #*---------------------------------------------------------*
        wget https://ftp.halifax.rwth-aachen.de/eclipse/technology/epp/downloads/release/2023-03/R/eclipse-java-2023-03-R-linux-gtk-x86_64.tar.gz -O eclipse.tar.gz
        tar -xf eclipse.tar.gz -o eclipse
        rm -r eclipse.tar.gz


        #*---------------------------------------------------------*
        #*               Configuration du monitoring               *
        #*---------------------------------------------------------*
        # ssh -i $rsa_key $username@$server_ip "wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --stable-channel --claim-token YysGS6QXeRjcI-dVA09iQIknkdwBpU_EIWIaSHjsM5DagHaHmka_sAE9c8X46ptoYZNKFea32a41lcKQFV1mF388Mo6vBV2Meu-2Gx01IHwtCvD9uqBa8Ysj0qgJWMr-g6eT8Tg --claim-rooms 856a9f09-d6be-49a2-86a8-b61125a0ada2 --claim-url https://app.netdata.cloud"


        #*---------------------------------------------------------*
        #*           Configuration du serveur Nextcloud            *
        #*---------------------------------------------------------*
        admin_login="nextcloud-admin"
        admin_passwd="N3x+ClOuD"
        # ssh -i $rsa_key $username@$server_ip "apt install snapd -y"
        # ssh -i $rsa_key $username@$server_ip "snap install core"
        # ssh -i $rsa_key $username@$server_ip "snap install nextcloud"
        # ssh -i $rsa_key $username@$server_ip "/snap/bin/nextcloud.manual-install $admin_login $admin_passwd"


else 
        if [ -d "/home/shared" ]; then
                rm -r /home/shared
        fi
        
        crontab -r
        
        rm -r eclipse

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
#                 ssh -n -i $rsa_key $username@$server_ip "mail --subject \"$name $surname, votre compte à été créé !\" --exec \"set sendmail=smtp://${sender_mail/@/%40}:$sender_passwd;auth=LOGIN@smtp.office365.com:587\" --append \"From:mael.grellier-neau@isen-ouest.yncrea.fr\" mael.grellier-neau@isen-ouest.yncrea.fr <<< \"Bonjour, 

# Bonne nouvelle, votre compte est désormais disponible !
# Pour pouvoir vous connectez, il vous suffit de vous munir de votre identifiant ainsi que votre mot de passe : 
#         Identifiant : $login
#         Mot de passe : $password

# A des fin de sécurité, lors de votre 1er connexion, vous devrez changer votre mot de passe.
# Cordialement.\""
                

                #*---------------------------------------------------------*
                #*            Sauvegarde sur le serveur distant            *
                #*---------------------------------------------------------*
                save_name="save_$login.tgz"

                #Routine de sauvegarde automatique qui compresse le dossier a_sauver de l'utilisateur 
                #et l'envoie sur le serveur distant, puis supprime l'archive sur le pc
                crontab -l | { cat; echo "0 23 * * 1-5 tar -czvf $save_name /home/$login/a_sauver && scp -i $rsa_kay $save_name $username@$server_ip:/home/saves && rm $save_name"; } | crontab -

                
                

                #*---------------------------------------------------------*
                #*                Installation de Eclipse                  *
                #*---------------------------------------------------------*
                ln -s eclipse/eclpise /home/$login/eclipse    
                


                
                #*---------------------------------------------------------*
                #*           Configuration du serveur Nextcloud            *
                #*---------------------------------------------------------*
                #creer un utlisateur nextcould avec un mot de passe
                export OC_PASS=$password
                /snap/bin/nextcloud.occ user:add --password-from-env --display-name="$name $surname" $login  
                
        fi
#https://stackoverflow.com/questions/28927162/why-process-substitution-does-not-always-work-with-while-loop-in-bash
done < <(awk 'NR>1' $input_file)