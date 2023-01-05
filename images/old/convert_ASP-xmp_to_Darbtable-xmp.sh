#!/bin/bash

#clear

RecursePath="/home/johan/Bilder/Fotografier"
#RecursePath="/home/johan/Bilder/testfotografier/asp_to_dt_xmp"

recurse ()
{
    for i in "$1"/*; do
	
	#Kollar om vi ska rekursera ner i en katalog:
	if [ -d "$i" ]; then
	    # Följande echo-sats visar katalog-namnet innan vi går in i den:
#	    echo "$i" 
	    # Vi anropar funktionen med katalognamnet eftersom if-satsen ovan säger att $i var en katalog:
	    recurse "$i"
#	    Counter=0

	    #Annars är $i en fil:
	elif [ -f "$i" ]; then

#	    FilePath=$(dirname "$i")
#	    echo $FilePath

	    #Kör python-scriptet på .nef.xmp-filer:
	    if [ ${i: -7} == "nef.xmp" ]; then
#		echo "$i"
		/home/johan/scripts/images/afp2xmp.py -p -w "$i"|grep Error
	    fi

	    # Följande echo-sats visar aktuellt filnamn:
#	    echo "$i"

	    #När alla xmp-filer är behandlade, nollställ räknaren:
#	    Counter=$[Counter + 1]
#	    echo $Counter
	fi
    done
    
#    Görs utanför for-loopen i varje katalog...:
#    katalog=$(dirname "$i")
#    echo "Det fanns $Counter filer i $katalog"
}
recurse $RecursePath
