#!/bin/bash

# Flyttar alla borttagna xmp-filer från papperskorgen till rätt katalog

TrashPath="$HOME/.local/share/Trash/files"

for i in *.xmp; do
	   
    NefBase="$i"
    MainDirectory=$(echo $NefBase|cut -c1-4)
    SubDirectory=$(echo $NefBase|cut -c1-10)
    PathToCopyTo="$MainDirectory"/"$SubDirectory"
    
    if [ -d "$PathToCopyTo" ]; then
	mv -v "$i" $HOME/Bilder/Fotografier/"$PathToCopyTo"
    else
	echo "Katalogen heter säkert något annat. $i"
	mv -v "$i" $HOME/Bilder/Fotografier/"$MainDirectory"/
    fi
    
done
