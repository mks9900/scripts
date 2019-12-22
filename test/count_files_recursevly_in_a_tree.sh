#!/bin/bash

#clear

RecursePath="/home/johan/tmp"

recurse ()
{
    for i in "$1"/*; do
	
	#Kollar om vi ska rekursera ner i en katalog:
	if [ -d "$i" ]; then
	    recurse "$i"
	    Counter=0
	#Kollar om vi har en med en fil att göra:
	elif [ -f "$i" ]; then
	    #	    echo "Nu kördes python-scriptet!"
	    Counter=$[Counter + 1]
	    #	    echo $Counter
	fi
    done
    
    #Görs utanför for-loopen i varje katalog...:
    katalog=$(dirname "$i")
    echo "Det fanns $Counter filer i $katalog"
}
recurse $RecursePath
