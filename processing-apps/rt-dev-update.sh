#!/bin/bash
clear
#
# Felhantering:
#
set -e
#
Tstart="$(date +%s)"
#
# Definitioner:
#
source=$HOME/rt-dev_source
baseTargetPath="$HOME/rt"
wasteBin=$HOME/.local/share/Trash/files

cd $source
#
echo "====================================================================================="
echo "Vill du uppdatera koden?"
select svar in  Ja Nej; do
    case $svar in
	Ja ) echo "Uppdaterar..."; git pull;break;;
        Nej ) echo "Ok, går vidare med kodbasen som den är nu."; break;;
    esac
done
#
echo "====================================================================================="
echo "Vill du fortsätta med kompileringen?"
select svar in  Ja Nej; do
    case $svar in
	Ja ) echo "Ok, går vidare." ;break;;
        Nej ) echo "Ok, avslutar."; exit 0;
    esac
done
#
echo "====================================================================================="
echo "Hur vill du kompilera RawTherapee?"
select svar in  release relwithdebinfo debug; do
    case $svar in
        release ) buildType=$svar;echo "Du valde $buildType. "; break;;
        relwithdebinfo ) buildType=$svar; echo "Du valde $buildType"; break;;
	debug ) buildType=$svar; echo "Du valde $buildType"; break;;
    esac
done

echo "====================================================================================="
echo "Vill du vill du städa från förra kompileringen?"
select svar in  Ja Nej; do
    case $svar in
	Ja ) echo "========================================================================" 
	     echo "Ok, kör make clean före make install:";
	     cd $source
	     rm -rf build
	     mkdir build
	     cd build
	     echo "Konfigurerar RawTherapee:"
	     echo "====================================================================" 

	     cmake -DCMAKE_BUILD_TYPE="$buildType" \
		   -DPROC_TARGET_NUMBER="2" \
		   -DBUILD_BUNDLE="ON" \
		   -DCACHE_NAME_SUFFIX="5-dev" \
		   -DWITH_LTO="OFF" \
		   ..

	     echo "===================================================================="
	     break;;
	
	Nej ) echo "Ok, städar inte utan kör make install direkt nu."; break;;
    esac
done

#
# Kompilera:
#

cd "$source"/build

if [ $? -eq 0 ]; then
    echo "====================================================================================="
    echo "Kompilerar och installerar RT i $source/build:"
    make -j8 install
    echo "====================================================================================="
    echo "Installationen i $source klar."
    echo "====================================================================================="
else
    echo "====================================================================================="
    echo "Kompileringen misslyckades. Avbryter." && exit 1;
    echo "====================================================================================="
fi

#
datum=`date --rfc-3339=date`
tid=`date |awk '{print $4}'|sed -e 's/:/_/g'`

cd $source

#Ta reda på vilken gren vi använt denna gång:
branch=$(git branch |grep "*" |awk '{print $2}')

#Ta reda på gren och binärtyp vi använt denna gång:
usedTarget="$baseTargetPath""_""$branch""_""$buildType"

#
#echo "Flyttar katalogen från $source/build/$buildType till $HOME och döper om den till $oldTarget-$datum-$tid."
#

# Egentligen samma som oldTarget, men snyggare så här:
newTarget="$baseTargetPath""_""$branch""_""$buildType"

#
# Kontroll om målkatalogen finns, annars skapas den:
if [ ! -d "$usedTarget" ]; then
    echo "==================================================================================="
    echo "Katalogen" $usedTarget "finns ej, den skapas nu."
    echo "==================================================================================="
    mkdir -p "$usedTarget"
else
    echo "Katalogen $usedTarget fanns. Går vidare nu."
fi

#
# Måste först döpa om den gamla installationen om den finns:
mv $usedTarget $usedTarget"-"$datum"-"$tid
#
# Måste därefter skapa katalogen newTarget:
mkdir "$newTarget"
cp -r $source/build/$buildType/* "$newTarget/"
#
# Ta reda på och skriv ut tiden det tog att bygga allt:
Ttotal="$(($(date +%s)-Tstart))"
echo "====================================================================================="
echo "Allt klart! Hela processen tog $Ttotal sekunder."
echo "====================================================================================="


# Uppdateras versionsnumret genom att vi inte kör cmake varje gång?
# Hur funkar det med att köra cp på rad 115 ist f mv som tidigare?
