#!/bin/bash

cd $HOME/Dropbox/Pictures/Bilder_och_filmer/2019
#cd $HOME/tmp

Tstart="$(date +%s)"

for i in *.heic; do
    BaseName=$(basename "$i")
    FileNameWOExt="${BaseName%.*}"
    /usr/bin/heif-convert "$i" "$FileNameWOExt".jpg
    /usr/bin/gio trash "$i"
done


Ttotal="$(($(date +%s)-Tstart))"
       
echo "Det tog $Ttotal sekunder!"
