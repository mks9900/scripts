#!/bin/bash

#clear

Count=`ls -1 *.JPG 2>/dev/null | wc -l`

if [ $Count = 0 ]
then 
    echo "Inga jpeg-filer finns, avbryter!"
    exit; else

    echo
    echo "Det finns $Count JPG-filer"
    echo
   
    for jpegFile in *.JPG; do
	
	FileDate="`exiv2 "$jpegFile"|grep timestamp|awk '{print $4}'|sed -e 's/:/-/g'`"
	FileTime="`exiv2 "$jpegFile"|grep timestamp|awk '{print $5}'|sed -e 's/:/./g'`" #|cut -c1-5`" #skär bort sekundrarna...
#	FocalLength="`exiv2 "$JPGFile"|grep Focal|awk '{print $4}'|cut -d'.' -f1`"
#	ISOSpeed="`exiv2 "$JPGFile"|grep "ISO speed"|awk '{print $4}'`"
#	Aperture="`exiv2 "$JPGFile"|grep Aperture|awk '{print $3}'|grep F|sed -e s'/\./-/'|sed -e s'/F/f/'`" #Byt ut punkten mot _
#	CameraModel="`exiv2 "$JPGFile"|grep "Camera model"|awk '{print $4}'|sed -e 's/:/-/g'`"
	FileName=$FileDate"_"$FileTime

	mv -iv "$jpegFile" "$FileName".jpg
		
    done
    
fi
