#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Musiktill NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

#
# Definitioner:
#
Source=$HOME/Documents
Try="`cat /etc/mtab|awk '{print $1}'|grep dokument`"
DevSource="//ng-nas/dokument"
NgNas=/home/johan/backup_nas
Lacie_1T=/media/LACIE1TB/backup
ExtDiskTwo=/media/backup-ext/backup

#
# Slut definitioner
#

echo "Till vilken enhet vill du säkerhetskopiera?"
select enhet in Alla NAS Lacie1T ExtDiskTwo; do
    case $enhet in
	Alla ) echo "Säkerhetskopierar till alla backup-enheter.";
	       # Synka till ng-nas om den är monterad, annars avbryt:
	       echo "=========================================================="
	       echo "Speglar till ng-nas:"
	       echo "=========================================================="
	       if [ "$DevSource" = "$Try" ]; then
		   /usr/bin/rsync -hlrtvz --delete $Source $NgNas
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		   Nas_Success=0
	       fi

	       # Synka till Lacie1Tb om den är monterad, annars avbryt:
	       if [ -d "$Lacie_1T" ]; then
		   echo "=========================================================="
		   echo "Speglar till Lacie 1Tb:"
		   echo "=========================================================="
		   /usr/bin/rsync -hlrtvz --delete $Source $Lacie_1T
		   Lacie_1T_Success=1; 
	       else
		   echo "=========================================================="
		   echo "Lacie1Tb-disken är ej monterad, synkar ej denna."
		   echo "=========================================================="
		   Lacie_1T_Success=0
	       fi

	       # Synka till ext-disk om den är monterad, annars avbryt:
	       if [ -d "$ExtDiskTwo" ]; then
		   echo "=========================================================="
		   echo "Speglar till ext-disk:"
		   echo "=========================================================="
		   /usr/bin/rsync -hlrtvz --delete $Source $ExtDiskTwo
		   ExtDiskTwo_Success=1; 
	       else
		   echo "=========================================================="
		   echo "Extdisk-disken är ej monterad, synkar ej denna."
		   echo "=========================================================="
		   ExtDiskTwo_Success=0
	       fi

 	       break;;

	NAS ) echo "=========================================================="
	      echo "Speglar till ng-nas:"
	      echo "=========================================================="
	      # Synka till ng-nas om den är monterad, annars avbryt:
	       if [ "$DevSource" = "$Try" ]; then
		   /usr/bin/rsync -lrtvz --delete $Source $NgNas
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $Source. Synkar ej denna."
		   Nas_Success=0
	       fi
	       break;;
	      
	Lacie1T ) echo "=========================================================="
		    echo "Speglar till Lacie 1000 Gb:"
		    echo "=========================================================="
		    # Synka till lacie1000 om den är monterad, annars avbryt:
		    if [ -d "$Lacie_1T" ]; then
			/usr/bin/rsync -lrtvz --delete $Source $Lacie_1T
			Lacie_1T_Success=1; 
		    else
			echo "Lacie1000Gb-disken är ej monterad, synkar ej denna."
			Lacie_1T_Success=0;
		    fi
		    break;;

	ExtDiskTwo ) echo "=========================================================="
		     echo "Speglar till ExtDiskTwo:"
		     echo "=========================================================="
		     
		     # Synka till ext-disk om den är monterad, annars avbryt:
		     if [ -d "$ExtDiskTwo" ]; then
			 echo "=========================================================="
			 echo "Speglar till ext-disk:"
			 echo "=========================================================="
			 /usr/bin/rsync -lrtvz --delete $Source $ExtDiskTwo
			 ExtDiskTwo_Success=1; 
		     else
			 echo "=========================================================="
			 echo "Extdisk-disken är ej monterad, synkar ej denna."
			 echo "=========================================================="
			 ExtDiskTwo_Success=0
		    fi
		    
    esac
done

echo "Backup av Dokumenten kördes den" `date` "till $enhet" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo 
echo " $Source till $NgNas: $Nas_Success"
echo " $Source till $Lacie_1T: $Lacie_1T_Success"
echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo "=========================================================="
