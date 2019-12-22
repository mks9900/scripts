#!/bin/bash

# Flyttar alla sidecar-filer som ej har en tillhörande Fuji raf-fil till papperskorgen.

RecursePath="$HOME/Pictures/Fotografier/"

# För tester:
#RecursePath="$HOME/tmp"

recurse ()
{
    for i in "$1"/*; do
	if [ -d "$i" ]; then
            #echo "dir: $i"
            recurse "$i"
	elif [ -f "$i" ]; then

	    BaseName=$(basename "$i")
	    FileNameWOExt="${BaseName%.*}"
	    Extension="${BaseName##*.}"

	    SubBaseName="${FileNameWOExt%.*}"
	    SubExtension="${FileNameWOExt##*.}"
	    
	    Raf="$FileNameWOExt".raf
	    RAF="$FileNameWOExt".RAF
	    SubRaf="$SubBaseName".raf
	    SubRAF="$SubBaseName".RAF

	    FilePath=$(dirname "$i")

	    if  [[ ( "$Extension" = "xmp" ) || ( "$Extension" = "pp3" ) ]] ; then
		if [[ ( -e "$FilePath"/"$Raf" ) || ( -e "$FilePath"/"$RAF" ) ]] ; then
		    :
		elif  [[ ( "$SubExtension" = "raf" ) || ( "$SubExtension" = "RAF" ) ]] ; then
		    if [[ ( -e "$FilePath"/"$SubRaf" ) || ( -e "$FilePath"/"$SubRAF" ) ]] ; then
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
