#!/bin/bash

#clear

Count=`ls -1 *.NEF 2>/dev/null | wc -l`

if [ $Count = 0 ]
then 
    echo "Inga nef-filer finns, avbryter!"
    exit; else

    echo
    echo "Det finns $Count nef-filer"
    echo
    Counter=1   
    for RawFile in *.NEF; do
	
	FileDate="`exiv2 "$RawFile"|grep timestamp|awk '{print $4}'|sed -e 's/:/-/g'`"
	FileTime="`exiv2 "$RawFile"|grep timestamp|awk '{print $5}'|sed -e 's/:/-/g'`" #|cut -c1-5`" #skär bort sekundrarna...
	FocalLength="`exiv2 "$RawFile"|grep Focal|awk '{print $4}'|cut -d'.' -f1`"
	ISOSpeed="`exiv2 "$RawFile"|grep "ISO speed"|awk '{print $4}'`"
	Aperture="`exiv2 "$RawFile"|grep Aperture|awk '{print $3}'|grep F|sed -e s'/\./-/'|sed -e s'/F/f/'`" #Byt ut punkten mot _
#	LensMaker="`exiv2 -pa "$RawFile"|grep "LensIDNumber"|awk '{print $4}'`"
#	LensID="`exiv2 -pa "$RawFile"|grep "Exif.NikonLd3.LensIDNumber"|awk '{print $5"_"$6"-"$7}'`"
	CameraMaker="`exiv2 "$RawFile"|grep "Camera model"|awk '{print $4}'|sed -e 's/:/-/g'`"
	CameraModel="`exiv2 "$RawFile"|grep "Camera model"|awk '{print $5}'|sed -e 's/:/-/g'`"
#	FileName=$FileDate"_kl-"$FileTime"_"$LensMaker"_"$FocalLength""mm_ISO$ISOSpeed"_"$Aperture
	FileName=$FileDate"_kl"$FileTime"_"$CameraModel"_"$FocalLength"mm_"$Aperture"_ISO""$ISOSpeed"
#	mv -vi "$RawFile" "$FileName".nef
	mv -v "$RawFile" "$FileName""_"$Counter.nef
	Counter=$[Counter + 1]
			
    done
    
fi
