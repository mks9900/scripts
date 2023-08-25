#!/bin/zsh

Source=/Volumes/"NIKON Z 6"/DCIM/100NCZ_6
Target=/Users/johanthor/Pictures/photo_import_tmp
PhotoPath=/Users/johanthor/Pictures/photo_imports

clear

#set -e

# Felhantering för mål- och källkataloger:
if [ ! -d "$Source" ]; then
    echo "=============================================================================="
    echo "Katalogen" $Source "finns ej, förmodligen är kortet ej monterat. Avbryter."
    echo "=============================================================================="
    exit ;
else

    if [ ! -d "$Target" ]; then
	echo "=========================================================================="
	echo "Katalogen" $Target "finns ej, förmodligen är disken ej monterad. Avbryter."
	echo "=========================================================================="
	exit ;
    else

# TODO: Felhantering om det redan finns kataloger/filer i import som är samma som på kortet!

	echo
	echo "=========================================================================="
	echo "Flyttar alla råfiler till målet:"
	echo "=========================================================================="

	Amount="$(du -chsm $Source|awk '{print $1}'|head -1|sed -e 's/M//'|sed -e "s/\(\.[0-9]\).*/\1/g")"
	#Amount="$(echo "$Amount2"|sed -e "s/\(\.[0-9]\).*/\1/g")"

	Tstart="$(date +%s)"

	cp -av "$Source"/*.NEF "$Target"
	echo "\nNu är alla filer kopierade från minneskortet till iCloud."

	# Felhantering om Ttrans=0!...
	Ttrans="$(($(date +%s)-Tstart))"

	cd "$Target"

	Count="$(ls -1 *.NEF 2>/dev/null | wc -l)"

	echo
	echo "Det finns $Count flyttade NEF-filer."
	echo
	echo
	echo "========================================================================="
	echo "Döper om varje fil till något mer meningsfullt:"
	echo "========================================================================="

	# Felhantering för *.NEF finns nedan:

	if [ $Count = 0 ]
	then
	    echo "Inga filer finns, avbryter!"
	    exit; else

	    Counter=1
	    for RawFile in "$Target"/*.NEF; do
                # OBS! exiv2 ändrar format beroende på vilket språk terminalen har...
                # Man kan alltså få ändra $x nedan:
		FileDate="`exiv2 "$RawFile"|grep timestamp|awk '{print $4}'|sed -e 's/:/-/g'`"
		FileTime="`exiv2 "$RawFile"|grep timestamp|awk '{print $5}'|sed -e 's/:/-/g'`" #|cut -c1-5`" #skär bort sekundrarna...
		FocalLength="`exiv2 "$RawFile"|grep length|awk '{print $4}'|cut -d'.' -f1`"
		ISOSpeed="`exiv2 "$RawFile"|grep "ISO"|awk '{print $4}'`"
		Aperture="`exiv2 "$RawFile"|grep Aperture|awk '{print $3}'|grep F|sed -e s'/\./-/'|sed -e s'/F/f/'`" #Byt ut punkten mot _
#		LensMaker="`exiv2 -pa "$RawFile"|grep "LensIDNumber"|awk '{print $4}'`"
#		LensID="`exiv2 -pa "$RawFile"|grep "Exif.NikonLd3.LensIDNumber"|awk '{print $5"_"$6"-"$7}'`"
		#CameraMaker="`exiv2 "$RawFile"|grep "make"|awk '{print $3}'|sed -e 's/:/-/g'`"
		CameraModel="`exiv2 "$RawFile"|grep "model"|awk '{print $4,$5$6}'|sed -e 's/ /_/g'`"
#		FileName=$FileDate"_kl-"$FileTime"_"$LensMaker"_"$FocalLength""mm_ISO$ISOSpeed"_"$Aperture
		FileName=$FileDate"_kl"$FileTime"_"$CameraModel"_"$FocalLength"mm_"$Aperture"_ISO""$ISOSpeed"

		if [ ! -d "$FileDate" ]; then
		    Counter=1
		    mkdir -p "$FileDate"
		    mv -v "$RawFile" "$FileDate"/"$FileName""_"$Counter.nef
		    Counter=$[Counter + 1]
		else
		    mv -v "$RawFile" "$FileDate"/"$FileName""_"$Counter.nef
		    echo "$FileDate"/"$FileName""_"$Counter.nef
		    Counter=$[Counter + 1]
		fi

	    done

	fi
    fi
fi

echo
echo
echo "================================================================================="
echo "Filerna kopieras/flyttas till rätt kataloger i foto-strukturen, baserat på yyyy/yyyy-mm-dd."
echo "================================================================================="

for TempDir in *; do
    # echo $TempDir
    CurrentDirectory=$(pwd)
    Year="$(ls |sort|awk '{print $1}'|cut -c1-4|head -1)"
    if [ ! -d "$PhotoPath"/"$Year"/"$TempDir" ]; then
		echo "Katalogen finns ej: Flyttar hela katalogen..."
		mv -vi "$TempDir"/ "$PhotoPath"/"$Year"
		echo
    else
		echo "Katalogen finns: Kopierar filerna till katalogen..."
		cp -ai "$TempDir"/*.nef "$PhotoPath"/"$Year"/"$TempDir"
		echo "Städa manuellt undan bilderna i $TempDir!"
		echo
    fi
done

# Här kollas den sista tiden och subtraherar den första så att totalen fås:
Ttotal="$(($(date +%s)-Tstart))"

TransferRate="$(echo $Amount / $Ttrans|bc -l)"
# printf %.2f $(echo "$float/1.18" | bc -l)
# echo "scale=2; 100/3" | bc

echo
echo
echo "================================================================================="
echo -e "Överförde $Count filer om totalt $Amount Mbyte på $Ttrans sekunder."
echo -e "\nscale=2; ($TransferRate Mbyte per sekund)."
#echo -e "Överförde filerna från "$Source" till $Target."
echo
echo "Hela importen tog $Ttotal sekunder."
echo "================================================================================="
