#!/bin/bash
clear



# deps for ubuntu:
# build-essential libsdl2-dev python3-jsonschema libjson-glib-dev libcolord-dev 
# libpugixml-dev libculr4-gnutls-dev xsltproc cmake curl pkg-config libgtk-3-dev 
# libgtkmm-3.0-dev liblensfun-dev librsvg2-dev liblcms2-dev libfftw3-dev 
# libiptcdata0-dev libtiff5-dev libcanberra-gtk3-dev
#
# Felhantering:
#
set -e
#
Tstart="$(date +%s)"
#
# Definitioner:
#
source=$HOME/program/code-dt
baseTargetPath=$HOME/program/dt-git

cd $source

#
#
# Uppdatera darktable via git:
#
echo "====================================================================================="
echo "Vill du uppdatera koden?"
select svar in Ja Nej; do
    case $svar in
        Ja ) echo "Hämtar uppdateringar:"; git submodule init; git submodule update; git pull; break;;
        Nej ) echo "Ok, kompilerar endast koden som den är nu."; break;;
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

# För de kommande stegen tar vi oss till..

echo "====================================================================================="
echo "Vill du städa från förra kompileringen?"
select svar in  Ja Nej; do
    case $svar in
	Ja )	echo "====================================================================================="
		echo "Ok, rensar!";
		echo "====================================================================================="
		rm -rf "$source/build/";
		mkdir $source/build
		cd "$source"/build
		echo "Konfigurerar darktable:"
		echo "====================================================================================="
		#		cmake -DCMAKE_BUILD_TYPE=Release ..
		$source/build.sh --build-type Release --prefix $source/build --jobs 8 --enable-openmp --enable-opencl --enable-openexr --disable-lua --disable-webp --disable-unity --disable-kwallet --disable-flickr --enable-map --enable-camera

		echo "====================================================================================="
		break;;
        Nej ) echo "Ok, städar inte utan kör make install direkt nu.";
	      break;;
    esac
done
#
cd "$source"/build
#
# Kompilera:
#
echo "====================================================================================="
echo "Kompilerar och installerar darktable i $source/build:"
#make -j8 # BEHÖVS VERKLIGEN DETTA - GÖRS DET INTE I BUILD.SH OVAN?

echo "====================================================================================="
echo "Installationen i /home/johan/dt-git_master klar."

#
datum=`date --rfc-3339=date`
tid=`date |awk '{print $5}'|sed -e 's/:/_/g'`

cd $source

#Ta reda på vilken gren vi använt denna gång:
branch=$(git branch |awk '{print $2}')

#Ta reda på gren och binärtyp vi använt denna gång:
usedTarget="$baseTargetPath""_""$branch"

#
#echo "Flyttar katalogen från $source/build/ till $HOME och döper om den till $oldTarget-$datum-$tid."
#

# Egentligen samma som oldTarget, men snyggare så här:
newTarget="$baseTargetPath""_""$branch"

#
# Kontroll om målkatalogen finns, annars skapas den:
if [ ! -d "$usedTarget" ]; then
    echo "==================================================================================="
    echo "Katalogen" $usedTarget "finns ej, den skapas nu."
    echo "==================================================================================="
    mkdir -p "$usedTarget"
    cp -r $source/build/* "$newTarget/"
else
    # Måste först döpa om den gamla installationen om den finns:
    echo "Katalogen $usedTarget fanns. Döpte om den och går vidare nu."
    mv $usedTarget $usedTarget"-"$datum"-"$tid
    # Måste därefter skapa katalogen newTarget:
    mkdir "$newTarget"
    cp -r $source/build/* "$newTarget/"
fi

# Länkar binären till ~/bin:
# ln -s $usedTarget/bin/darktable $HOME/bin/

# Ta reda på och skriv ut tiden det tog att bygga allt:
Ttotal="$(($(date +%s)-Tstart))"
echo "====================================================================================="
echo "Allt klart! Hela processen tog $Ttotal sekunder."
echo "====================================================================================="
