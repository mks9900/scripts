#!/bin/bash

#Source1=/run/media/johan/CARDREADER/DCIM/
Source1=/run/media/johan/SanDisk_SD_SDDR-289_31216000343-1/DCIM/
Source2="134_FUJI"
Source="$Source1""$Source2"
Target=$HOME/Pictures/Fotografier/import-xt1-raw
PhotoPath=$HOME/Pictures/Fotografier

clear

#set -e

# Felhantering för mål- och källkataloger:
if [ ! -d "$Source" ]; then
    echo "==================================================================================="
    echo "Katalogen" $Source "finns ej, förmodligen är kortet ej monterat. Avbryter."
    echo "==================================================================================="
    exit ; 
else
    
    if [ ! -d "$Target" ]; then
	echo "==================================================================================="
	echo "Katalogen" $Target "finns ej, förmodligen är disken ej monterad. Avbryter."
	echo "==================================================================================="
	exit ; 
    else
	
# TODO: Felhantering om det redan finns kataloger/filer i import som är samma som på kortet!
	
	echo
	echo "==================================================================================="
	echo "Flyttar alla råfiler till målet:" #samt att vi kollar vad tiden är så vi kan räkna ut hur lång tid allt tog i slutet:
	echo "==================================================================================="

	Amount="`ls -s --block-size=M "$Source"|awk '{print $2}'|head -1|sed -e 's/M//'`"
	Tstart="$(date +%s)"

	cp -av "$Source"/*.RAF "$Target"
	echo "Nu är alla filer kopierade!"

	Ttrans="$(($(date +%s)-Tstart))"
#Felhantering om Ttrans=0!
	
	cd "$Target"

	Count=`ls -1 *.RAF 2>/dev/null | wc -l`
	echo
	echo "Det finns $Count RAF-filer"
	echo
	echo
	echo "==================================================================================="
	echo "Sedan byts namnet på dem och filerna flyttas till rätt datumkatalog..."
	echo "==================================================================================="

# Felhantering för *.RAF finns nedan:

	if [ $Count = 0 ]
	then 
	    echo "Inga filer finns, avbryter!"
	    exit; else

	    Counter=1
	    for RawFile in "$Target"/*.RAF; do

		FileDate="`exiv2 "$RawFile"|grep timestamp|awk '{print $4}'|sed -e 's/:/-/g'`"
		FileTime="`exiv2 "$RawFile"|grep timestamp|awk '{print $5}'|sed -e 's/:/-/g'`" #|cut -c1-5`" #skär bort sekundrarna...
		FocalLength="`exiv2 "$RawFile"|grep Focal|awk '{print $4}'|cut -d'.' -f1`"
		ISOSpeed="`exiv2 "$RawFile"|grep "ISO speed"|awk '{print $4}'`"
		Aperture="`exiv2 "$RawFile"|grep Aperture|awk '{print $3}'|grep F|sed -e s'/\./-/'|sed -e s'/F/f/'`" #Byt ut punkten mot _
#		CameraMaker="`exiv2 "$RawFile"|grep "Camera make"|awk '{print $4}'|sed -e 's/:/-/g'`"
		CameraModel="`exiv2 "$RawFile"|grep "Camera model"|awk '{print $4}'|sed -e 's/:/-/g'`"
		FileName=$FileDate"_kl"$FileTime"_"$CameraModel"_"$FocalLength"mm_"$Aperture"_ISO""$ISOSpeed"

		if [ ! -d "$FileDate" ]; then
		    Counter=1
		    mkdir -p "$FileDate"
		    echo "Flyttar $RawFile till katalogen $FileDate."
		    mv -v "$RawFile" "$FileDate"/"$FileName""_"$Counter.raf
		    Counter=$[Counter + 1]
		else
		    mv -v "$RawFile" "$FileDate"/"$FileName""_"$Counter.raf
		    echo "$FileDate"/"$FileName""_"$Counter.raf
		    Counter=$[Counter + 1]		
		fi

	    done

	fi
    fi
fi

echo
echo
echo "==================================================================================="
echo "Filerna kopieras till rätt kataloger i foto-strukturen, baserat på yyyy/yyyy-mm-dd."
echo "==================================================================================="

# Varför visas ej pwd nedan?
# Kan även denna slås samman med den större for-loopen ovan?

for TempDir in *; do
    CurrentDirectory=$(pwd)
#    echo $pwd
    Year=`ls |sort|awk '{print $1}'|cut -c1-4|head -1`
    if [ ! -d "$PhotoPath"/"$Year"/"$TempDir" ]; then
	echo "Katalogen $PhotoPath/$Year/$TempDir finns ej: Flyttar allt."
	mv -vi "$TempDir"/ "$PhotoPath"/"$Year"
	echo
    else
	echo "Katalogen $PhotoPath/$Year/$TempDir finns: Kopierar..."
	cp -ai "$TempDir"/*.raf "$PhotoPath"/"$Year"/"$TempDir"
	echo
    fi
done

# Här kollas den sista tiden och subtraherar den första så att totalen fås:
Ttotal="$(($(date +%s)-Tstart))"

TransferRate=`echo "$Amount / $Ttrans"|bc -l | sed -e "s/\(\.[0-9]\).*/\1/g"`

echo
echo
echo "==================================================================================="
echo -e "Överförde $Count filer från "$Source" om $Amount Mbyte på $Ttrans sekunder \n($TransferRate Mbyte per sekund) till $Target."
echo
echo "Hela importen tog $Ttotal sekunder."
echo "==================================================================================="
