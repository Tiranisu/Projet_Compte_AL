#!/bin/bash

while IFS=";" read -r NAME SURNAME MAIL PASSWORD; do
    echo "$NAME"
    echo "$SURNAME"
    echo "$MAIL"
    echo "$PASSWORD"
done <"accounts.csv"