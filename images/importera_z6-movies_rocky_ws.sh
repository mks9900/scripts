#!/bin/zsh

MountTest=/media/johanthor/NIKON\ Z\ 6/
Source=/media/johanthor/NIKON\ Z\ 6/DCIM/101NCZ_6/
Target=/home/johanthor/raid_storage/Pictures/import_tmp/
PhotoPath=/home/johanthor/Nextcloud/Photos/raw_movies

clear

#set -e

# Felhantering för mål- och källkataloger:
if [ ! -d "$MountTest" ]; then
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
	echo "Flyttar alla filmer till målet:" #samt att vi kollar vad tiden är så vi kan räkna ut hur lång tid allt tog i slutet:
	echo "==================================================================================="

	Amount="$(du -chsm $Source|awk '{print $1}'|head -1|sed -e 's/M//'|sed -e "s/\(\.[0-9]\).*/\1/g")"
	Tstart="$(date +%s)"

	cp -av "$Source"/*.MOV "$Target"
	echo "\nNu är alla filmer kopierade från minneskortet!"

	#Felhantering om Ttrans=0!...
	Ttrans="$(($(date +%s)-Tstart))"

	cd "$Target"

	Count="$(ls -1 *.MOV 2>/dev/null | wc -l)"

	echo
	echo "Det finns $Count MOV-filer."
	echo
	echo
	echo "==================================================================================="
	echo "Döper om varje film till något mer meningsfullt:"
	echo "==================================================================================="

	if [ $Count = 0 ]
	then
	    echo "Inga filer finns, avbryter!"
	    exit; else

	    Counter=1
	    for Movie in "$Target"/*.MOV; do
        # OBS! exiv2 ändrar format beroende på vilket språk terminalen har...
			# Man kan alltså få ändra $x nedan:
			FileDate="`exiftool "$Movie"|grep "Create Date"|awk '{print $5}'|sed -e 's/:/-/g'|head -n 1`"
			FileTime="`exiftool "$Movie"|grep "Create Date"|awk '{print $6}'|sed -e 's/:/-/g'|head -n 1`"
			CameraModel="`exiftool "$Movie"|grep "Model"|head -n 1|awk '{print $3,$4,$5}'|sed -e 's/ /_/g'`"
			FocalLength="`exiftool "$Movie"|grep "Focal Length"|awk '{print $4}'|sed -e 's/:/-/g'|head -n 1`"
			Aperture="`exiftool "$Movie"|grep "AF Aperture"|awk '{print $4}'|sed -e s'/\.//'`"
			ISOSpeed="`exiftool "$Movie"|grep "ISO2"|head -n 1|awk '{print $3}'`"

			FileName=$FileDate"_kl"$FileTime"_"$CameraModel"_"$FocalLength"mm_f"$Aperture""_ISO""$ISOSpeed

			Year="`exiftool *.MOV|grep 'Create Date'|awk '{print $5}'|head -n1|cut -c1-4`"

		if [ ! -d "$FileDate" ]; then
		    Counter=1
			mkdir -p "$FileDate"
			# mkdir -p $FileDate
		    mv -v "$Movie" "$FileDate"/"$FileName""_"$Counter.mov
		    Counter=$[Counter + 1]

		else
			mv -v "$Movie" "$FileDate"/"$FileName""_"$Counter.mov
		    # echo "$FileDate"/"$FileName""_"$Counter.mov
		    Counter=$[Counter + 1]
		fi

	    done

	fi
    fi
fi

echo
echo
echo "==================================================================================="
echo "Filerna kopieras/flyttas till rätt kataloger i foto-strukturen, baserat på yyyy/yyyy-mm-dd."
echo "==================================================================================="

# for YearDir in *; do
#     # echo $TempDir
#     # CurrentDirectory=$(pwd)
#     # Year="$(ls |sort|awk '{print $1}'|cut -c1-4|head -1)"
# 	cd $YearDir
# 	# pwd

# 	for DateDir in *; do # == e.g. 2022-12-14
# 		cd $DateDir
# 		# ls
# 		Year="`exiftool *.mov|grep 'Create Date'|awk '{print $5}'|head -n1|cut -c1-4`"
# 		# echo "$Year"
# 		pwd
# 		cd ..
# 		if [ ! -d "$PhotoPath"/"$Year"/"$DateDir" ]; then
# 			echo "Katalogen finns ej: Flyttar hela katalogen..."
# 			mv -vi "$DateDir"/ "$PhotoPath"/"$Year"
# 			echo
# 		else
# 			echo "Katalogen finns: Kopierar filerna till katalogen..."
# 			cp -ai "$DateDir"/*.mov "$PhotoPath"/"$Year"/"$DateDir"
# 			echo "Städa manuellt undan bilderna i ~/tmp/$DateDir!"
# 			echo
# 		fi
# 	done

# done

for TempDir in *; do
    # echo $TempDir
    # CurrentDirectory=$(pwd)
	# Nedan funkar inte om det finns fler år, där något år inte skapats än. T.ex.
	# bilder från både 2022 och 2023.
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

echo
echo
echo "==================================================================================="
echo -e "Överförde $Count filer från om $Amount Mbyte på $Ttrans sekunder."
echo -e "\n($TransferRate Mbyte per sekund)."
#echo -e "Överförde filerna från "$Source" till $Target."
echo
echo "Hela importen tog $Ttotal sekunder."
echo "==================================================================================="
