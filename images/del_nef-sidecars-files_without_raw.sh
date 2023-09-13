#!/bin/bash

# Flyttar alla sidecar-filer som ej har en tillhörande Nikon nef-fil till papperskorgen.

RecursePath="$HOME/Nextcloud/Photos/raw_photos"

# För tester:
#RecursePath="$HOME/tmp"

recurse ()
{
    for i in "$1"/*; do
	if [ -d "$i" ]; then
            recurse "$i"
	elif [ -f "$i" ]; then

	    BaseName=$(basename "$i")
	    FileNameWOExt="${BaseName%.*}"
	    Extension="${BaseName##*.}"

	    SubBaseName="${FileNameWOExt%.*}"
	    SubExtension="${FileNameWOExt##*.}"

	    Nef="$FileNameWOExt".nef
	    NEF="$FileNameWOExt".NEF
	    SubNef="$SubBaseName".nef
	    SubNEF="$SubBaseName".NEF

	    FilePath=$(dirname "$i")

	    if  [[ ( "$Extension" = "xmp" ) || ( "$Extension" = "pp3" ) ]] ; then
		if [[ ( -e "$FilePath"/"$Nef" ) || ( -e "$FilePath"/"$NEF" ) ]] ; then
		    :
		elif  [[ ( "$SubExtension" = "nef" ) || ( "$SubExtension" = "NEF" ) ]] ; then
		    if [[ ( -e "$FilePath"/"$SubNef" ) || ( -e "$FilePath"/"$SubNEF" ) ]] ; then
			:
		    else
			/usr/bin/gio trash "$i"
		    fi
		fi
	    else
		:
	    fi
	fi
    done
}
recurse $RecursePath

# Bibble/ASP:
#.NEF.xmp

# darktable:
#.Nef.xmp

# Lightroom:
#.xmp

# RT:
#.pp3

# echo 00004.NEF.xmp|cut -d'.' -f1 = 00004
# echo 00004.NEF.xmp|cut -d'.' -f2 = NEF
# echo 00004.NEF.xmp|cut -d'.' -f3 = xmp
