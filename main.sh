#!/bin/bash

FICHIER=`cat accounts.csv`
for data in $FICHIER 
do
    echo $data
    NAME=`echo $data | awk -F";"`
    SURMANE=`echo $data | awk -F";"`
    MAIL=`echo $data | awk -F";"`
    PASSWORD=`echo $data | awk -F";"`
    echo "$NAME - $SURNAME - $MAIL - $MAIL - $PASSWORD"
done
