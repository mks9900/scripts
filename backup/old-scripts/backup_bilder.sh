#!/bin/zsh
#
# progress-feedback? Via "uxterm -e 'kommando'"?
#
# Synkar från /home/johan/Bilder till NAS och usb-diskarna.
# --delete tar bort filer vid målet som ej finns i källan.
#

SourceBase=$HOME
AllPath=Pictures
YearPath="$AllPath/Fotografier"
DevSource="//ng-nas-plan0/backup"
TRY="`cat /etc/mtab |grep backup_nas|awk '{print $1}'|grep ng-nas-plan0`"
NgNasBase=/home/johan/backup_nas

Source="/home/johan/cloud-storage/onedrive/Pictures"
NgNas="$NgNasBase"
OneTB_ntfs="$OneTB_ntfsBase"
#ExtDiskTwo="$ExtDiskTwoBase"

echo "Till vilken enhet vill du säkerhetskopiera?"
select enhet in Alla NAS OneTB_ntfs; do # onedrive; do 
    case $enhet in
	Alla ) echo "Speglar till NAS, OneTB_ntfs, ExtDiskTwo";
	       # Synka först till ng-nas om den är monterad, annars avbryt:
	       if [ "$DevSource" = "$TRY" ]; then
		   echo "Säkerhetskopierar till alla backup-enheter.";
		   echo "=========================================================="
		   echo "Speglar till ng-nas-plan0:"
		   echo "=========================================================="

		   /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --exclude 'Kamerabilder' --delete $Source $NgNas
		   Nas_Success=1; 
	       else
		   echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		   Nas_Success=0
	       fi

	       # Synka sedan till OneTB_ntfs om den är monterad, annars avbryt:
	       if [ -d "$OneTB_ntfs" ]; then
		   echo "=========================================================="
		   echo "Speglar till OneTB_ntfs:"
		   echo "=========================================================="
		   /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --exclude 'Kamerabilder' --delete $Source "$OneTB_ntfs"
		   OneTB_ntfs_Success=1; 
	       else
		   echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
		   OneTB_ntfs_Success=0;
	       fi

	       break;;
	
	NAS ) echo "Speglar till NAS:en.";
	      # Synka till ng-nas om den är monterad, annars avbryt:
	      if [ "$DevSource" = "$TRY" ]; then
		  echo "=========================================================="
		  echo "Speglar till ng-nas:"
		  echo "=========================================================="
		  /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --exclude 'Kamerabilder' --delete $Source $NgNas
#		  echo $Source/
#		  echo $NgNas/
		  Nas_Success=1; 
	      else
		  echo "Enheten $DevSource är ej monterad på $Source. Avbryter."
		  Nas_Success=0;
	      fi
	      break;;
	
	OneTB_ntfs ) echo "Speglar till OneTB_ntfs.";
		  # Synka till OneTB_ntfs om den är monterad, annars avbryt:
		  if [ -d "$OneTB_ntfs" ]; then
		      echo "=========================================================="
		      echo "Speglar till OneTB_ntfs:"
		      echo "=========================================================="
		      /usr/bin/rsync -hlrtvz --exclude 'lost+found' --exclude '.Trash-1000' --exclude 'Kamerabilder' --delete $Source "$OneTB_ntfs"
		      OneTB_ntfs_Success=1; 
		  else
		      echo "OneTB_ntfs-disken är ej monterad, synkar ej denna."
		      OneTB_ntfs_Success=0;
		  fi
		  
		  break;;
 		     
    esac
done

echo "Bilder," `date`" till $enhet" >> ~/Backup_dates_disks.txt

echo "=========================================================="
echo " Sammanställning av synk av följande enheter enligt nedan:"
echo 
echo " $Source till $NgNas: $Nas_Success"
echo " $Source till $OneTB_ntfs: $OneTB_ntfs_Success"
echo "=========================================================="
