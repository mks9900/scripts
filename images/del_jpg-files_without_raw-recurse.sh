#!/bin/bash

# Kör ej för 2011, då detta skript tar bort de jpg som skapats av dng-filer. Varför?
# För 2010 tas en bröllopsbild bort.
year=2019
RawPath="$HOME/Pictures/Fotografier/$year"
ExportPath="$HOME/diverse/Exports/$year"

# Eftersom det finns fler filer som vi vill ta bort i Exports, kollar vi varje fil där om den finns i Raw-filerna eller ej.
# Om den finns, görs inget och så går man vidare till nästa och kollar.
# Om den inte finns, tas jpg-filen bort och sen går man till nästa och kollar.

# Sätt ett årtal i en variabel kallad $Year
# Gå till Exports/$Year
# För varje jpg: läs in dess namn
  # Ta bort ändelsen och lägg till ändelsen "nef".
  # Kolla om filnamnet finns någonstans i Rawfilerna/Årtal/*
# Om det finns: gör inget och gå till nästa jpg
# Om det inte finns: flytta jpg-filen till Trash och gå till nästa jpg
# Upprepa för alla filer i årtal.


cd $ExportPath

RecursePath="$ExportPath"

recurse ()
{
    for i in "$1"/*; do
	if [ -d "$i" ]; then
	    recurse "$i"

	elif [ -f "$i" ]; then
	    #   k=0
	    jpgBaseName=$(basename "$i")
	    jpgFileNameWOExt="${jpgBaseName%.*}"
	    rawFileNameNEF="$jpgFileNameWOExt"".nef"
	    rawFileNameDNG="$jpgFileNameWOExt"".dng"
	    rawFileNameDNG="$jpgFileNameWOExt"".raf"
	    existsJPGInRawPath="$(find $RawPath -name "$jpgBaseName")"
	    
	    if [ "$existsJPGInRawPath" ] ; then
		:
	    else
		existsNEF="$(find $RawPath -name "$rawFileNameNEF")"
		existsDNG="$(find $RawPath -name "$rawFileNameDNG")"
		existsRAF="$(find $RawPath -name "$rawFileNameRAF")"
		    
		if [[ ( "$existsNEF" ) || ( "$existsDNG" ) || ( "$existsRAF" )]] ; then
		    :
		else
		    # k=$(expr $k + 1)
		    echo "Tar bort:" $jpgBaseName
	  	    /usr/bin/gio trash "$i"
		fi
	    fi
	    # echo "Tog bort" $k "st. jpg-filer."
      	fi
    done
}

recurse $RecursePath
