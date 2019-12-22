#!/bin/bash

#PhotoPath=$HOME/Pictures/Fotografier/
#RecursePath="/home/johan/Pictures/Fotografier/"
RecursePath="/home/johan/tmp/Pictures/Fotografier"
Extension_pp3=pp3
Extension_xmp=xmp
Extension_avi=avi
Extension_db=db
Extension_mp4=mp4

recurse ()
{
    for i in "$1"/*; do
        if [ -d "$i" ]; then
            #echo "dir: $i"
            recurse "$i"
        elif [ -f "$i" ]; then

	    BaseName=$(basename "$i")
            Extension_xmp="${BaseName##*.}"
	    Extension_avi="${BaseName##*.}"
	    Extension_pp3="${BaseName##*.}"
	    Extension_db="${BaseName##*.}"
	    Extension_mp4="${BaseName##*.}"

	    # ej xmp, pp3!
	    if  [[ ( "$Extension_xmp" = "xmp" ) || ( "$Extension_pp3" = "pp3" ) || ( "$Extension_avi" = "avi" ) || ( "$Extension_db" = "db" ) || ( "$Extension_mp4" = "mp4" ) ]] ; then
		# hoppa över den filen
                :
            else
		FocalLength="`exiv2 "$i"|grep Focal|awk '{print $4}'|cut -d'.' -f1`"
		echo "$FocalLength" >> ~/focallengths.txt
		
		FilePath=$(dirname "$i")
            fi
	fi
    done
}
recurse $RecursePath


# Filer att exkludera:
# .mip, .nef.pp3#
