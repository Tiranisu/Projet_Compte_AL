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