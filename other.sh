#!/bin/bash
echo "Que voulez-vous faire ?"
select i in "Voulez-vous faire une installation ?" "Néttoyer votre machine d'une installation ?"; do
        if [ "$i" = "Voulez-vous faire une installation ?" ]; then
                echo "Voulez-vous faire une installation ?"
                break
        elif [ "$i" = "Néttoyer votre machine d'une installation ?" ]; then
                echo "Bonjour madame"
                break
        else
                echo "mauvaise reponse"
        fi
done

mail --subject "Ceci est un test" --exec "set sendmail=smtp://mael.grellier-neau%40isen-ouest.yncrea.fr:68Mgn04N*;auth=LOGIN@smtp.office365.com:587" --append "From:mael.grellier-neau@isen-ouest.yncrea.fr" mael.grelneau@gmail.com <<< "<body>"

ssh mgrell25@10.30.48.100 'mail --subject "Ceci est un test" --exec "set sendmail=smtp://mael.grellier-neau%40isen-ouest.yncrea.fr:68Mgn04N*;auth=LOGIN@smtp.office365.com:587" --append "From:mael.grellier-neau@isen-ouest.yncrea.fr" guillaume.robin@isen-ouest.yncrea.fr <<< "coucou guillaume"'


smtp://[user[:pass][;auth=mech,...]@]host[:port][;params]
smtp://mael.grellier-neau%40isen-ouest.yncrea.fr:68Mgn04N*;auth=LOGIN@smtp.office365.com:587

ssh user1@192.168.0.100 "ls"






