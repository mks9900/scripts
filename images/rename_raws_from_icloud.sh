#!/bin/zsh

# Läser in alla filnamn i en katalog med en massa hämtade
# raw-filer från iCloud och sorterar in dem i mappar med
# aktuellt datum som scriptet skapar.


Source=/home/johanthor/raid_storage/raw_pictures_from_icloud_temp
Target=/home/johanthor/raid_storage/raw_pictures_from_icloud_temp
PhotoPath=/home/johanthor/Pictures/Raw/

clear


for FileName in *; do
    # echo $TempDir
    # CurrentDirectory=$(pwd)
	# Nedan funkar inte om det finns fler år, där något år inte skapats än. T.ex.
	# bilder från både 2022 och 2023.
    Year="$(ls |sort|awk '{print $1}'|cut -c1-4|head -1)"
	FileDate="$(ls $FileName|cut -c1-10|head -n1)"
    if [ ! -d "$PhotoPath"/"$Year"/"$FileName" ]; then
		echo "Katalogen finns ej: Flyttar hela katalogen..."
		echo $FileDate
		mkdir -p "$FileDate"
		mv -vi "$FileName" "$FileDate"/
		echo
    else
		echo "Katalogen finns: Kopierar filerna till katalogen..."
		# cp -ai "$FileName"/*.nef "$PhotoPath"/"$Year"/"$FileName"
		echo "Städa manuellt undan bilderna i $FileName!"
		echo
    fi
done
