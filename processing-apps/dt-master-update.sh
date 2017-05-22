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
source=$HOME/dt-src
baseTargetPath=$HOME/dt_git

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
		$HOME/dt-src/build.sh --enable-openmp --enable-opencl --enable-tethering --enable-geo --enable-openexr --prefix /home/johan/dt-master
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
#make -j8
sudo make -j8 install

echo "====================================================================================="
echo "Installationen i /usr/local klar."

#
datum=`date --rfc-3339=date`
tid=`date |awk '{print $4}'|sed -e 's/:/_/g'`


# Ta reda på och skriv ut tiden det tog att bygga allt:
Ttotal="$(($(date +%s)-Tstart))"
echo "====================================================================================="
echo "Allt klart! Hela processen tog $Ttotal sekunder."
echo "====================================================================================="
