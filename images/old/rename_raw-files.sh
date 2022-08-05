#!/bin/bash

#clear

RecursePath="/home/johan/Bilder/Fotografier/2015/2015-06-16"

recurse ()
{
    for i in "$1"/*; do
	if [ -d "$i" ]; then
	    recurse "$i"
	    Counter=0

	elif [ -f "$i" ]; then
	    BaseInputFileName=$(basename "$i")
	    FileNameWOExt="${BaseInputFileName%.*}"
	    nef="$FileNameWOExt".nef
	    NEF="$FileNameWOExt".NEF
	    FilePath=$(dirname "$i")
	    xmpBaseName="$FileNameWOExt"

	    #	    if  [[ ( "$FilePath"/"$NEF" = "$i" ) || ( "$FilePath"/"$nef" = "$i" ) ]]  ; then
	    if  [[ ( "$FilePath"/"$NEF" = "$i" ) || ( "$FilePath"/"$nef" = "$i" ) ]]  ; then
	       	Counter=$[Counter + 1]

#		Rawfilerna:
		FileDate="`exiv2 "$i"|grep timestamp|awk '{print $4}'|sed -e 's/:/-/g'`"
		FileTime="`exiv2 "$i"|grep timestamp|awk '{print $5}'|sed -e 's/:/-/g'`"
		LensMaker="`exiv2 -pa "$i"|grep "LensIDNumber"|awk '{print $4$5$6$7}'`"
		LensID="`exiv2 -pa "$i"|grep "LensIDNumber"|awk '{print $7}'`"
		FocalLength="`exiv2 "$i"|grep Focal|awk '{print $4}'|cut -d'.' -f1`"
		ISOSpeed="`exiv2 "$i"|grep "ISO speed"|awk '{print $4}'`"
		CameraMaker="`exiv2 "$i"|grep "Camera model"|awk '{print $4}'|sed -e 's/:/-/g'`"
		CameraModel="`exiv2 "$i"|grep "Camera model"|awk '{print $5}'|sed -e 's/:/-/g'`"
		Aperture="`exiv2 "$i"|grep Aperture|awk '{print $3}'|grep F|sed -e s'/\./-/'|sed -e s'/F/f/'`" # Byt ut decimalpunkten mot _
		NewFileName=$FileDate"_"$FileTime"_"$CameraMaker"_"$CameraModel"_"$FocalLength"_mm_ISO_"$ISOSpeed"_"$Counter
		#$FileDate"_kl"$FileTime"_"$LensMaker"_"$FocalLength""mm_ISO$ISOSpeed"_"$Aperture"__nr-"$Counter
		NewRawFileName="$NewFileName".nef

#		xmp-filerna:
		SideCarLR="$NewFileName".xmp
		SideCarRT1="$NewFileName".NEF.pp3
		SideCarRT2="$NewFileName".nef.pp3
		SideCarDT1="$NewFileName".NEF.xmp
		SideCarDT2="$NewFileName".nef.xmp

		mv "$i" "$FilePath"/"$NewRawFileName"
#		echo ""
#		echo "Nytt namn:             $NewRawFileName"
		
#               if [ -e "$FilePath"/"$xmpBaseName.xmp" ]; then
#		    :
#		    echo "SideCarLR:             $SideCarLR"
#		    mv "$FilePath"/"$xmpBaseName.xmp" "$FilePath"/"$SideCarLR"
#		fi
		
#		if [ -e "$xmpBaseName".NEF.pp3 ]; then
#		    :
#		    echo "SideCarRT1:            $SideCarRT2"
#		    mv "$FilePath"/"$xmpBaseName.NEF.pp3" "$FilePath"/"$SideCarRT2" # Behåll bara lower-case nef
#		fi
		
#		if [ -e "$xmpBaseName".pp3 ]; then
#		    :
#		    echo "SideCarRT2:            $SideCarRT2"
		    mv  "$FilePath"/"$xmpBaseName.pp3" "$FilePath"/"$SideCarRT2" # Behåll bara lower-case nef
#		fi
		
#		if [ -e "$xmpBaseName".NEF.xmp ]; then
#		    :
#		    echo "SideCarDT1:            $SideCarDT2"
#		    mv "$FilePath"/"$xmpBaseName.NEF.xmp" "$FilePath"/"$SideCarDT2" # Behåll bara lower-case nef
#		fi
	
#		if [ -e "$xmpBaseName".nef.xmp ]; then
#		    :
#		    echo "SideCarDT2:            $SideCarDT2"
#		    mv "$FilePath"/"$xmpBaseName.nef.xmp" "$FilePath"/"$SideCarDT2" # Behåll bara lower-case nef
#		fi
	    else
#		:
		echo "Ingen raw-fil:         $i"
	    fi
	fi
    done
}
recurse $RecursePath
