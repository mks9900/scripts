La#!/bin/bash
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Musiktill NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

#
# Definitioner:
#
Source=$HOME/Music
Target=$HOME/backup_nas/
DevSource="//ng-nas/backup"
Try="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas`"
Lacie_1T=/media/johan/LACIE1TB/backup
# Backupa ej musik till denna mindre disk:
#ExtDiskTwo=/media/johan/backup-ext/backup

echo "Till vilken enhet vill du säkerhetskopiera?"
select enhet in Alla NAS Lacie1000; do
    case $enhet in
	Alla ) echo "Säkerhetskopierar till alla backup-enheter.";
	       echo "=========================================================="
	       echo "Speglar till ng-nas:"
	       echo "=========================================================="
	       # Synka till ng-nas om sdb1 är monterad, annars avbryt:
	       if [ "$DevSource" = "$Try" ]; then
		   /usr/bin/rsync -hlrtvz --delete $Source $Target
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		   Nas_Success=0
	       fi
	       
	       # Synka till lacie1000 om den är monterad, annars avbryt:
	       echo "=========================================================="
	       echo "Speglar till Lacie 1000 Gb:"
	       echo "=========================================================="
	       if [ -d "$Lacie_1T" ]; then
		   /usr/bin/rsync -hlrtvz --delete $Source $Lacie_1T
		   Lacie_1T_Success=1; 
	       else
		   echo "Lacie1000Gb-disken är ej monterad, synkar ej denna."
		   Lacie_1T_Success=0;
	       fi

	       # # Synka till extdisktwo om den är monterad, annars avbryt:
	       # echo "=========================================================="
	       # echo "Speglar till extdisktwo:"
	       # echo "=========================================================="
	       # if [ -d "$ExtDiskTwo" ]; then
	       # 	   /usr/bin/rsync -hlrtvz --delete $Source $ExtDiskTwo
	       # 	   ExtDiskTwo_Success=1; 
	       # else
	       # 	   echo "ExtDiskTwo-disken är ej monterad, synkar ej denna."
	       # 	   ExtDiskTwo_Success=0;
	       # fi
	       
	       break;;
	       
	NAS ) echo "=========================================================="
	      echo "Speglar till ng-nas:"
	      echo "=========================================================="
	       # Synka till ng-nas om sdb1 är monterad, annars avbryt:
	       if [ "$DevSource" = "$Try" ]; then
		   /usr/bin/rsync -hlrtvz --delete $Source $NgNas
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		   Nas_Success=0;
	       fi
	       break;;

	Lacie1000 ) echo "=========================================================="
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

	# # Synka till extdisktwo om den är monterad, annars avbryt:
	# ExtDiskTwo)  echo "=========================================================="
	# 	     echo "Speglar till extdisktwo:"
	# 	     echo "=========================================================="
	# 	     # Synka till ExtdiskTwo om den är monterad, annars avbryt:
	# 	     if [ -d "$ExtDiskTwo" ]; then
	# 		 /usr/bin/rsync -hlrtvz --delete $Source $ExtDiskTwo
	# 		 ExtDiskTwo_Success=1; 
	# 	     else
	# 		 echo "ExtDiskTwo-disken är ej monterad, synkar ej denna."
	# 		 ExtDiskTwo_Success=0;
	# 	     fi
		     
	# 	     break;;
	
    esac
done

echo "Backup av Musik-katalogen kördes den" `date` "till NAS ($Nas_Success), Lacie1Tb ($Lacie_1T_Success), ExtDiskTwo ($ExtDiskTwo)" >> ~/backup_dates_types.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo 
echo " $Source till $Target: $Nas_Success"
echo " $Source till $Lacie_1T: $Lacie_1T_Success"
#echo " $Source till $ExtDiskTwo: $ExtDiskTwo_Success"
echo "=========================================================="
